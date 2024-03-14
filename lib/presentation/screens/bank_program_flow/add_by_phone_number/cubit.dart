import 'dart:async';

import 'package:duration/duration.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/add_by_phone_number.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

Timer? timer;
int secondsLeft = 60;
String phone = "";

class AddBankByPhoneNumberCubit extends Cubit<AddBankByPhoneNumberState> {
  final AddBankByPhoneNumberUseCase addBankByPhoneNumberUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  final BankCardType bankCardType;

  AddBankByPhoneNumberCubit({required this.bankCardType})
      : super(AddBankByPhoneNumberState(
          phoneController: MaskedTextController(
              mask: '+7 000 000 00 00',
              text: "+7",
              //TODO фикс бага, когда подставляется +7 при удалении номера и повторном вводе
              //CursorBehaviour.end помогает на андроиде, но возникают проблемы с удалением последних цифр на IOS
              cursorBehavior: PlatformWrap.isIOS ? CursorBehaviour.unlocked : CursorBehaviour.end)
            ..selection = const TextSelection(baseOffset: 2, extentOffset: 2),
        )) {
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  _onCreate() async {
    if (phone.isNotEmpty) {
      emit(state.copyWith(
        step: AddBankByPhoneNumberStep.code,
        showTimer: true,
        timerSecondsLeft: secondsLeft,
      ));
      state.phoneController.text = phone;
    }
  }

  onEnterPhone(String phoneNumber) {
    final newError = TextValidators.phoneNumber(phoneNumber);
    if (newError == null) {
      emit(state.copyWith(canPressContinue: true, phoneNumberError: () => null));
    } else {
      emit(state.copyWith(canPressContinue: false, phoneNumberError: () => null));
    }
  }

  onEnterCode(String code) {
    state.code = code;
    if (code.length < 4) {
      emit(state.copyWith(canPressContinue2: false));
    } else {
      emit(state.copyWith(canPressContinue2: true));
    }
  }

  onContinuePressed() async {
    emit(state.copyWith(loading: true));
    final result = await addBankByPhoneNumberUseCase.search(
      phone: state.phoneController.text.replaceAll(" ", ""),
      type: getIndexByActiveCard(bankCardType),
    );
    if (result.isSuccess) {
      timer?.cancel();
      phone = state.phoneController.text.replaceAll(" ", "");
      timer = Timer.periodic(seconds(1), (timer) {
        secondsLeft -= 1;
        if (secondsLeft == 0) {
          timer.cancel();
          secondsLeft = 60;
          phone = "";
        }
      });
      emit(state.copyWith(step: AddBankByPhoneNumberStep.code, timerSecondsLeft: secondsLeft, showTimer: true));
    } else {
      switch (result.failureValue as Failure) {
        case Failure.snackBar:
          _messageController.add(result.message);
          break;
        case Failure.inputError:
          emit(state.copyWith(phoneNumberError: () => result.message));
          break;
      }
    }
    emit(state.copyWith(loading: false));
  }

  onContinuePressed2() async {
    emit(state.copyWith(loading: true));
    final result = await addBankByPhoneNumberUseCase.confirm(
      phone: state.phoneController.text.replaceAll(" ", "").replaceAll("+", ""),
      code: state.code,
      bankType: bankCardType,
    );
    if (result.isSuccess) {
      await _getCardsUseCase.get();
      _messageController.add(AddBankByPhoneNumberState.successAddProgram);
      _metricsUseCase.sendEvent(event: eventName[cardAddingSuccess]!, type: MetricsEventType.message);
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(type: MetricsEventType.alert, error: result.message);
    }
    emit(state.copyWith(loading: false));
  }

  void onResendCodePressed() {
    onContinuePressed();
  }

  onTimerEnd() {
    emit(state.copyWith(showTimer: false));
  }

  @override
  Future<void> close() async {
    await Future.wait([
      _messageController.close(),
    ]);
    return super.close();
  }
}
