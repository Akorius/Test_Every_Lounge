import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/metrics/metric_backend_type.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';

abstract class SignInWithEmailUseCase {
  Future<Result> sendEmailStep([String email = "", bool resend = false]);

  Future<Result<EveryLoungeToken>> sendCodeStep(String code);
}

class SignInWithEmailUseCaseImpl implements SignInWithEmailUseCase {
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final LoginApi _loginApi = getIt();
  final TokensStorage _tokensStorage = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt();

  String _email = "";

  @override
  Future<Result> sendEmailStep([String email = "", bool resend = false]) async {
    if (resend) {
      email = _email;
    } else {
      _email = email;
    }

    late final MetricEmailType emailType;
    late final String tag;
    if (!resend) {
      emailType = MetricEmailType.emailCodeRequest;
      tag = "emailCodeRequest";
    } else {
      emailType = MetricEmailType.emailCodeResend;
      tag = "emailCodeResend";
    }
    _metricsUseCase.sendEvent(
      event: eventName[emailAuthClick]!,
      type: MetricsEventType.message,
    );
    _metricUseCase.send(
      authType: MetricAuthType.emailSignIn,
      step: MetricStep.begin,
      status: MetricStatus.success,
    );
    try {
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.requestSending,
        status: MetricStatus.success,
        emailType: emailType,
      );
      final result = await _loginApi.sendEmail(email: email);
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.gettingResponse,
        status: MetricStatus.success,
        emailType: emailType,
      );
      return Result.success(result);
    } catch (e, s) {
      Log.exception(e, s, tag);
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.gettingResponse,
        status: MetricStatus.error,
        emailType: emailType,
        error: e.toString(),
      );
      return Result.failure("Не удалось запросить код подтверждения на email.");
    }
  }

  @override
  Future<Result<EveryLoungeToken>> sendCodeStep(String code) async {
    late final EveryLoungeToken token;
    try {
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.requestSending,
        status: MetricStatus.success,
        emailType: MetricEmailType.emailCodeConfirm,
      );
      token = await _loginApi.sendCode(code: code, email: _email);
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.gettingResponse,
        status: MetricStatus.success,
        emailType: MetricEmailType.emailCodeConfirm,
      );
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.finish,
        status: MetricStatus.success,
      );
    } on DioError catch (e, s) {
      late final String message;
      if (e.response?.data["code"] == 404) {
        message = "Неправильный код.";
      } else {
        message = "Не удалось проверить код.";
      }
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.gettingResponse,
        status: MetricStatus.error,
        emailType: MetricEmailType.emailCodeConfirm,
        error: e.toString(),
      );
      Log.exception(e, s, "sendCodeStep");
      return Result.failure(message);
    } catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.emailSignIn,
        step: MetricStep.gettingResponse,
        status: MetricStatus.error,
        emailType: MetricEmailType.emailCodeConfirm,
        error: e.toString(),
      );
      Log.exception(e, s, "sendCodeStep");
      return Result.failure("Не удалось проверить код.");
    }

    ///Сохраняем токены
    _tokensStorage.accessToken = token.accessToken;
    _tokensStorage.refreshToken = token.refreshToken;

    ///Получаем пользователя
    final result = await _getUserUseCase.get();

    if (!result.isSuccess) {
      return Result.failure(result.message);
    }

    _metricsUseCase.sendEvent(event: eventName[emailAuthSuccess]!, type: MetricsEventType.message);

    return Result.success(token);
  }
}
