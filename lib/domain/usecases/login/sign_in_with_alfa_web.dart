import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';
import 'package:everylounge/domain/entities/social_auth_type.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/failure_value.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithAlfaWebUseCase {
  ///Получаем ссылку авторизации
  ///Отслыаем метрики
  Future<Result<String>> getAlfaAuthLink();

  ///Обрабатываем результат, который завершился с ошибкой
  ///Возвращаем токены обратно в случае успеха
  Future<Result<EveryLoungeToken>> signInWithWebViewResult(AlfaIdResult? result);
}

class SignInWithAlfaWebUseCaseImpl implements SignInWithAlfaWebUseCase {
  final LoginApi _loginApi = getIt();
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocialTokenUseCase = getIt();

  @override
  Future<Result<String>> getAlfaAuthLink() async {
    try {
      var result = await _loginApi.getAlfaAuthLink();
      if (result.isNotEmpty) {
        _metricUseCase.send(
          authType: MetricAuthType.alfaWeb,
          step: MetricStep.begin,
          status: MetricStatus.success,
        );
        return Result.success(result);
      }
    } catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.alfaWeb,
        step: MetricStep.begin,
        status: MetricStatus.error,
        error: e.toString(),
      );
      Log.exception(e, s, "getAlfaAuthLink");
    }
    return Result.failure("Не удалось получить ссылку авторизации");
  }

  @override
  Future<Result<EveryLoungeToken>> signInWithWebViewResult(AlfaIdResult? result) async {
    ///Обрабатываем результат, который завершился с ошибкой
    if (!(result?.isSuccess ?? false)) {
      final MetricStatus status;
      final String message;
      switch (result?.failureValue) {
        case null:
        case AlfaIdFailure.cancelledByUser:
          message = "Вход отменён пользователем";
          status = MetricStatus.cancelledByUser;
          break;
        case AlfaIdFailure.webResourceError:
        case AlfaIdFailure.noCodeInRedirectUri:
        case AlfaIdFailure.apiCallError:
        case AlfaIdFailure.clientNotFound:
        default:
          message = result!.message;
          status = MetricStatus.error;
          break;
      }
      _metricUseCase.send(
        authType: MetricAuthType.alfaWeb,
        step: MetricStep.tokenObtaining,
        status: status,
        error: message,
      );
      if (result?.failureValue != AlfaIdFailure.cancelledByUser && result?.failureValue != AlfaIdFailure.clientNotFound) {
        Log.exception(Exception(message), null, "processWebViewResult");
      }
      return Result.failure(message, result?.failureValue ?? AlfaIdFailure.cancelledByUser);
    }

    ///Обмениваем социальный токен на токен Everylounge
    final resultSignIn = await _signInWithSocialTokenUseCase.signIn(
      SocialAuthType.alfaWeb,
      result!.tokenPayload,
    );

    ///Возвращаем токены EveryLounge в случае успеха
    return resultSignIn;
  }
}
