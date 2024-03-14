import 'dart:async';

import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_alfa_web.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_apple.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_email.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_google.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_sdk.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_web.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_web_web.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/settings/settings.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/failure_value.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

import 'state.dart';

class OtherLoginCubit extends Cubit<OtherLoginState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase = getIt();
  final SignInWithAppleUseCase _signInWithAppleUseCase = getIt();
  final SignInWithEmailUseCase _signInWithEmailUseCase = getIt();
  final SignInWithAlfaWebUseCase _signInWithAlfaWebUseCase = getIt();
  final SignInWithTinkoffWebUseCase _signInWithTinkoffWebUseCase = getIt();
  final SignInWithTinkoffWebToWebUseCase _signInWithTinkoffWebToWebUseCase = getIt();
  final SignInWithTinkoffSDKUseCase _signInWithTinkoffSDKUseCase = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  final SettingsUseCase _settingsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  OtherLoginCubit() : super(OtherLoginState()) {
    _onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  late final List _termsOfUser;

  void _onCreate() async {
    var settings = await _settingsUseCase.getSettings();
    _termsOfUser = [
      '${settings.value.actualRulesId ?? ''}/rules.pdf',
      '${settings.value.actualPolicyId ?? ''}/policy.pdf',
      '${settings.value.actualOfferId ?? ''}/offer.pdf',
    ];

    emit(state.copyWith(
      hideTinkoff: _findOutHideParamsUseCase.isHideTinkoffIdLogin(),
      hideAlfa: production && _findOutHideParamsUseCase.isHideAlfaIdLogin(),
    ));
  }

  String getLink(int index) {
    return '${ApiClient.filesUrl}${_termsOfUser[index]}';
  }

  cleanEmailError() {
    emit(state.copyWith(emailError: null));
  }

  checkCanPressEmail(String text) {
    emit(state.copyWith(canPressEmailLogin: text.contains('@')));
  }

  void checkEmail(String text) {
    final newError = TextValidators.email(text);
    if (state.emailError != newError) {
      emit(state.copyWith(emailError: newError));
      _metricsUseCase.sendEvent(error: eventName[emailError]!, type: MetricsEventType.alert);
    }
  }

  sendEvent(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  onEmailContinuePressed(String text) async {
    checkEmail(text);
    if (state.emailError != null) return;
    if (state.emailLoading) return;
    emit(state.copyWith(canPress: false, emailLoading: true));
    final result = await _signInWithEmailUseCase.sendEmailStep(text);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(event: eventName[emailAuthClick]!, type: MetricsEventType.click);
    } else {
      _messageController.add(OtherLoginState.navigateToCodeSend);
    }
    emit(state.copyWith(canPress: true, emailLoading: false));
  }

  void hideTinkoffLoader() {
    emit(state.copyWith(canPress: true, tinkoffLoading: false));
  }

  onTinkoffIdPressed() async {
    _metricsUseCase.sendEvent(event: eventName[tinkoffAuthClick]!, type: MetricsEventType.click);

    emit(state.copyWith(canPress: false, tinkoffLoading: true));
    if (PlatformWrap.isIOS) {
      final result = await _signInWithTinkoffWebUseCase.launchWebView();
      if (result.isSuccess) {
        _messageController.add(OtherLoginState.navigateToTinkoffWebView);
      } else {
        _messageController.add(result.message);
        _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
      }
    } else if (PlatformWrap.isAndroid) {
      final result = await _signInWithTinkoffSDKUseCase.signIn();
      if (result.isSuccess) {
        _messageController.add(OtherLoginState.navigateToMainScreen);
      } else {
        _messageController.add(result.message);
        _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
      }
    } else if (PlatformWrap.isWeb) {
      _signInWithTinkoffWebToWebUseCase.createUri();
    }
    emit(state.copyWith(canPress: true, tinkoffLoading: false));
  }

  onAlfaIdPressed() async {
    _metricsUseCase.sendEvent(event: eventName[alphaAuthClick]!, type: MetricsEventType.click);

    emit(state.copyWith(canPress: false, alfaLoading: true));
    final result = await _signInWithAlfaWebUseCase.getAlfaAuthLink();
    if (result.isSuccess) {
      emit(state.copyWith(alfaAuthLink: result.value));
      _messageController.add(OtherLoginState.navigateToAlfaWebView);
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(canPress: true, alfaLoading: false));
  }

  void onAlfaWebViewReturned(AlfaIdResult? aResult) async {
    emit(state.copyWith(canPress: false, alfaLoading: true));
    final result = await _signInWithAlfaWebUseCase.signInWithWebViewResult(aResult);

    if (result.isSuccess) {
      _messageController.add(OtherLoginState.navigateToMainScreen);
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
          _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);

          break;
      }
    }
    emit(state.copyWith(canPress: true, alfaLoading: false));
  }

  void onTinkoffWebViewReturned(TinkoffIdResult? tResult) async {
    emit(state.copyWith(canPress: false, tinkoffLoading: true));
    final result = await _signInWithTinkoffWebUseCase.signInWithWebViewResult(tResult);

    if (result.isSuccess) {
      _messageController.add(OtherLoginState.navigateToMainScreen);
    } else {
      switch (result.failureValue) {
        case TinkoffIdFailure.cancelledByUser:
          break;
        case TinkoffIdFailure.webResourceError:
        case TinkoffIdFailure.noCodeInRedirectUri:
        case TinkoffIdFailure.apiCallError:
        default:
          _messageController.add(result.message);
          _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);

          break;
      }
    }
    emit(state.copyWith(canPress: true, tinkoffLoading: false));
  }

  onGooglePressed() async {
    _metricsUseCase.sendEvent(event: eventName[googleAuthClick]!, type: MetricsEventType.click);

    if (state.googleLoading) return;
    emit(state.copyWith(canPress: false, googleLoading: true));
    final result = await _signInWithGoogleUseCase.signIn();
    if (result.isSuccess) {
      _messageController.add(OtherLoginState.navigateToMainScreen);
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(canPress: true, googleLoading: false));
  }

  onApplePressed() async {
    _metricsUseCase.sendEvent(event: eventName[appleAuthClick]!, type: MetricsEventType.click);

    if (state.appleLoading) return;
    emit(state.copyWith(canPress: false, appleLoading: true));
    final result = await _signInWithAppleUseCase.signIn();
    if (result.isSuccess) {
      _messageController.add(OtherLoginState.navigateToMainScreen);
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(canPress: true, appleLoading: false));
  }

  @override
  Future<void> close() {
    _messageController.close();
    return super.close();
  }
}
