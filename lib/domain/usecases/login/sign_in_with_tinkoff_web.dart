import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';
import 'package:everylounge/domain/entities/social_auth_type.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithTinkoffWebUseCase {
  ///Проверяем, что clientIdTinkoffId и mobileRedirectUri были успешно получены
  ///Отслыаем метрики
  Future<Result> launchWebView();

  ///Обрабатываем результат, который завершился с ошибкой
  ///Возвращаем токены обратно в случае успеха
  Future<Result<EveryLoungeToken>> signInWithWebViewResult(TinkoffIdResult? result);
}

class SignInWithTinkoffWebUseCaseImpl implements SignInWithTinkoffWebUseCase {
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final RemoteConfigStorage _remoteStorage = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocialTokenUseCase = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  @override
  Future<Result> launchWebView() async {
    ///Проверяем, что clientIdTinkoffId и mobileRedirectUri были успешно получены
    final clientId = _remoteStorage.tinkoffIdClientId;
    final redirectUri = _remoteStorage.tinkoffIdRedirectUri;
    if (clientId.isEmpty || redirectUri.isEmpty) {
      final message = "clientId: $clientId или mobileRedirectUri: $redirectUri пустая строка";
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffWeb,
        step: MetricStep.begin,
        status: MetricStatus.error,
        error: message,
      );
      Log.exception(message, null, "generateUriForTinkoffIdWeb");
      return Result.failure("Не удалось получить информацию о поставщике входа");
    }

    _metricUseCase.send(
      authType: MetricAuthType.tinkoffWeb,
      step: MetricStep.begin,
      status: MetricStatus.success,
    );
    return Result.success(true);
  }

  @override
  Future<Result<EveryLoungeToken>> signInWithWebViewResult(TinkoffIdResult? result) async {
    ///Обрабатываем результат, который завершился с ошибкой
    if (!(result?.isSuccess ?? false)) {
      final MetricStatus status;
      final String message;
      switch (result?.failureValue) {
        case null:
        case TinkoffIdFailure.cancelledByUser:
          message = "Вход отменён пользователем";
          status = MetricStatus.cancelledByUser;
          break;
        case TinkoffIdFailure.webResourceError:
        case TinkoffIdFailure.noCodeInRedirectUri:
        case TinkoffIdFailure.apiCallError:
          Log.exception(Exception(result!.message), null, "processWebViewResult");
          message = result.message;
          status = MetricStatus.error;
          break;
      }
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffWeb,
        step: MetricStep.tokenObtaining,
        status: status,
        error: message,
      );
      return Result.failure(message, result?.failureValue ?? TinkoffIdFailure.cancelledByUser);
    }

    ///Обмениваем социальный токен на токен Everylounge
    final resultSignIn = await _signInWithSocialTokenUseCase.signIn(
      SocialAuthType.tinkoffWeb,
      result!.tokenPayload.accessToken,
      tinkoffRefreshToken: result.tokenPayload.refreshToken,
    );

    /// Обновляем данные о проходах
    await _tinkoffPassUseCase.getPassageInfo(result.tokenPayload.accessToken);

    ///Возвращаем токены EveryLounge в случае успеха
    return resultSignIn;
  }
}
