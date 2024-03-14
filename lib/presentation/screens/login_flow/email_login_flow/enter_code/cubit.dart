import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_email.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/change_email.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class EnterCodeCubit extends Cubit<EnterCodeState> {
  final SignInWithEmailUseCase _signInWithEmailUseCase = getIt();
  final ChangeEmailUseCase _changeEmailUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  final bool changeEmail;

  EnterCodeCubit({required this.changeEmail}) : super(EnterCodeState());

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  onCodeChanged(String code) {
    state.code = code;
    if (code.length == 4) {
      emit(state.copyWith(codeValid: true));
    } else {
      if (!state.codeValid) return;
      emit(state.copyWith(codeValid: false));
    }
  }

  onContinuePressed() async {
    if (state.loading) return;
    emit(state.copyWith(loading: true));
    final Result result;
    if (changeEmail) {
      result = await _changeEmailUseCase.confirmCode(code: state.code);
    } else {
      result = await _signInWithEmailUseCase.sendCodeStep(state.code);
    }
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    } else {
      _messageController.add(EnterCodeState.navigateToMainScreen);
    }
    emit(state.copyWith(loading: false));
  }

  onResendPressed() async {
    _metricsUseCase.sendEvent(event: eventName[repeatOtpClick]!, type: MetricsEventType.click);

    if (state.loading) return;
    emit(state.copyWith(loading: true));
    final Result result;
    if (changeEmail) {
      result = await _changeEmailUseCase.requestEmailChange(email: "", resend: true);
    } else {
      result = await _signInWithEmailUseCase.sendEmailStep("", true);
    }

    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    } else {
      emit(state.copyWith(showTimer: true));
      _messageController.add("Код был отправлен повторно.");
      _metricsUseCase.sendEvent(event: "Код был отправлен повторно.", type: MetricsEventType.message);
    }
    emit(state.copyWith(loading: false));
  }

  onTimerEnd() {
    emit(state.copyWith(showTimer: false));
  }

  @override
  Future<void> close() {
    _messageController.close();
    return super.close();
  }
}
