import 'dart:async';

import 'package:collection/collection.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/bank/selected_bank.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/usecases/login/add_alfa_id_to_user.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user_sdk.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user_web.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_alfa_web.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/check_success_attach_id.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_bank.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/failure_value.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

import 'state.dart';

class SelectPaymentMethodCubit extends Cubit<SelectPaymentMethodState> {
  final GetUserUseCase _getUserUseCase = getIt();
  final AddTinkoffIdToUserSDKUseCase _addTinkoffIdToUserSDKUseCase = getIt();
  final AddTinkoffIdToUserWebUseCase _addTinkoffIdToUserWebUseCase = getIt();
  final AddAlfaIdToUserUseCase _addAlfaIdToUserUseCase = getIt();

  final GetCardsUseCase _getCardsUseCase = getIt();
  final FindOutHideBanksUseCase _findOutHideBanksUseCase = getIt();
  final SignInWithAlfaWebUseCase _signInWithAlfaWebUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();
  final CheckSuccessAttachIdUseCase _checkSuccessAttachIdUseCase = getIt();

  final _messageController = StreamController<String>();
  late final StreamSubscription<User> _userSubscription;

  SelectPaymentMethodCubit() : super(const SelectPaymentMethodState()) {
    _onCreate();
  }

  _onCreate() {
    attachCardCubit.listen(
      (event) => emit(state.copyWith(methodInHandle: () => event.cardAttaching == true ? PaymentMethod.bankCard : null)),
      _messageController.add,
    );
    _userSubscription = _getUserUseCase.stream.listen((user) {
      emit(
        state.copyWith(
          excludeTinkoff: user.tinkoffId != null,
          excludeTochka: user.passages?.firstWhereOrNull((element) => element.bank == ActiveBank.tochka) != null,
          excludeAlfa: user.passages?.firstWhereOrNull((element) => element.bank == ActiveBank.alfa) != null,
          excludeAlfaPrem: user.alfaId != null,
          hideTochka: production && _findOutHideBanksUseCase.hideTochkaBank,
          hideBeelineKZ: production && _findOutHideBanksUseCase.hideBeelineKZBank,
          hideAlfaPrem: production && _findOutHideBanksUseCase.hideAlfaPremium,
        ),
      );
    });
  }

  final AttachCardCubit attachCardCubit = getIt();

  Stream<String> get messageStream => _messageController.stream;

  final String excludeMesssage = "Выбранный способ оплаты уже подключен к Вашему аккаунту.";

  onPaymentMethodPressed(PaymentMethod method) async {
    switch (method) {
      case PaymentMethod.tinkoff:
        if (state.excludeTinkoff) {
          _messageController.add(excludeMesssage);
        } else {
          onContinueWithTinkoffIdPressed();
        }
        break;
      case PaymentMethod.tochka:
        if (state.excludeTochka) {
          _messageController.add(excludeMesssage);
        } else {
          _messageController.add(SelectPaymentMethodState.navigateToTochka);
          _metricsUseCase.sendEvent(event: eventName[addPaymentPrivilegesTochkaBankClick]!, type: MetricsEventType.click);
        }
        break;
      case PaymentMethod.beelineKZ:
        if (state.excludeBeelineKZ) {
          _messageController.add(excludeMesssage);
        } else {
          _messageController.add(SelectPaymentMethodState.navigateToBeelineKZ);
          _metricsUseCase.sendEvent(event: eventName[addPaymentPrivilegesBeelineKZClick]!, type: MetricsEventType.click);
        }
        break;
      case PaymentMethod.alfa:
        if (state.excludeAlfa) {
          _messageController.add(excludeMesssage);
        } else {
          _messageController.add(SelectPaymentMethodState.navigateToAlfa);
          _metricsUseCase.sendEvent(event: eventName[addPaymentPrivilegesAlphaClubClick]!, type: MetricsEventType.click);
        }
        break;
      case PaymentMethod.alfaPrem:
        if (state.excludeAlfaPrem) {
          _messageController.add(excludeMesssage);
        } else {
          emit(state.copyWith(canPress: false, methodInHandle: () => PaymentMethod.alfaPrem));
          final result = await _signInWithAlfaWebUseCase.getAlfaAuthLink();
          if (result.isSuccess) {
            emit(state.copyWith(alfaAuthLink: result.value));
            _messageController.add(SelectPaymentMethodState.navigateToAlfaPrem);
            _metricsUseCase.sendEvent(event: eventName[addPaymentPrivilegesAlphaClubClick]!, type: MetricsEventType.click);
          } else {
            emit(state.copyWith(canPress: true, methodInHandle: () => null));
          }
        }
        break;
      case PaymentMethod.bankCard:
        attachCardCubit.openAttachCardScreen();
        break;
    }
  }

  onContinueWithTinkoffIdPressed() async {
    emit(state.copyWith(canPress: false, methodInHandle: () => PaymentMethod.tinkoff));

    _metricsUseCase.sendEvent(event: eventName[addPaymentTinkoffPayClick]!, type: MetricsEventType.click);

    Result result;
    if (PlatformWrap.isIOS) {
      result = await _addTinkoffIdToUserWebUseCase.launchWebView();
      if (result.isSuccess) {
        _messageController.add(SelectPaymentMethodState.navigateToTinkoffWebView);
      } else {
        _messageController.add(result.message);
        _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
      }
    } else {
      result = await _addTinkoffIdToUserSDKUseCase.add();
      if (result.isSuccess) {
        await _getCardsUseCase.get().then((value) => Future.delayed(ms(100)));
        _messageController.add("TinkoffID успешно привязан к аккаунту");
        _messageController.add(SelectPaymentMethodState.navigateToProfile);
        //TODO рефакторить после добавления на бэке
        // await getCard();
      } else {
        _messageController.add(result.message);
        _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
      }
    }
    emit(state.copyWith(canPress: true, methodInHandle: () => null));
  }

  void onAlfaWebViewReturned(AlfaIdResult? aResult) async {
    emit(state.copyWith(canPress: false, methodInHandle: () => PaymentMethod.alfaPrem));
    final result = await _addAlfaIdToUserUseCase.add(aResult);
    if (result.isSuccess) {
      await _getCardsUseCase.get().then((value) => Future.delayed(ms(100)));
      _messageController.add("AlfaID успешно привязан к аккаунту");
      _messageController.add(SelectPaymentMethodState.navigateToProfile);
      //TODO рефакторить после добавления на бэке
      // await getCard();
    } else {
      switch (result.failureValue) {
        case AlfaIdFailure.cancelledByUser:
          break;
        case AlfaIdFailure.webResourceError:
        case AlfaIdFailure.noCodeInRedirectUri:
        case AlfaIdFailure.apiCallError:
        case AlfaIdFailure.clientNotFound:
        default:
          _messageController.add(result.message);
          _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);

          break;
      }
    }
    emit(state.copyWith(canPress: true, methodInHandle: () => null));
  }

  onFromTinkoffIdWebReturned(TinkoffIdResult? tResult) async {
    emit(state.copyWith(canPress: false, methodInHandle: () => PaymentMethod.tinkoff));
    final result = await _addTinkoffIdToUserWebUseCase.addWithWebViewResult(tResult);
    if (result.isSuccess) {
      await _getCardsUseCase.get().then((value) => Future.delayed(ms(100)));
      _messageController.add("TinkoffID успешно привязан к аккаунту");
      _messageController.add(SelectPaymentMethodState.navigateToProfile);
      //TODO рефакторить после добавления на бэке
      // await getCard();
    } else {
      switch (result.failureValue) {
        case TinkoffIdFailure.cancelledByUser:
          break;
        case TinkoffIdFailure.webResourceError:
        case TinkoffIdFailure.noCodeInRedirectUri:
        case TinkoffIdFailure.apiCallError:
        default:
          _messageController.add(result.message);
                  _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);

          break;
      }
    }
    emit(state.copyWith(canPress: true, methodInHandle: () => null));
  }

  Future<void> getCard() async {
    await _getCardsUseCase.get();
    Future.delayed(ms(100));
    var activeCardResult = await _getCardsUseCase.active();
    if (activeCardResult.isSuccess) {
      emit(
        state.copyWith(activeCard: activeCardResult.value),
      );
      _messageController.add(SelectPaymentMethodState.showSuccess);
      _checkSuccessAttachIdUseCase.setShowedSuccessModal(activeCardResult.value);
    }
  }

  @override
  Future<void> close() {
    return Future.wait([
      _messageController.close(),
      _userSubscription.cancel(),
      attachCardCubit.unListen(),
    ]).then((value) => super.close());
  }
}
