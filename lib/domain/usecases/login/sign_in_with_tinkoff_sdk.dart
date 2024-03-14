import 'package:app_links/app_links.dart';
import 'package:duration/duration.dart';
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
import 'package:flutter/services.dart';
import 'package:tinkoff_id_flutter/entities/token_payload.dart';
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithTinkoffSDKUseCase {
  ///Получаем [redirectUri] из удаленного хранилища
  ///Проверяем, что приложение Tinkoff Bank доступно
  ///Начинаем слушать первую входящую ссылку из приложения тиньков, не ждём
  ///Запускаем приложение Tinkoff Bank
  ///Дожидаемся первой входящей ссылки из приложения Tinkoff Bank
  ///Получаем токен из входящей ссылки
  ///Обмениваем социальный токен на токен Everylounge
  ///Возращаем полученный набор токенов
  Future<Result<EveryLoungeToken>> signIn();
}

class SignInWithTinkoffIdUseCaseImpl implements SignInWithTinkoffSDKUseCase {
  final TinkoffIdFlutter _tinkoffId = getIt();
  final RemoteConfigStorage _remoteStorage = getIt();
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocialTokenUseCase = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn() async {
    ///Получаем [redirectUri] из удаленного хранилища
    final redirectUri = _remoteStorage.tinkoffIdRedirectUri;
    if (redirectUri.isEmpty) {
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffApp,
        step: MetricStep.begin,
        status: MetricStatus.error,
        error: "redirectUri: $redirectUri. Строка пустая.",
      );
      Log.exception(Exception("redirectUri: $redirectUri. Строка пустая."));
      const message = "Не удалось получить информацию о поставщике входа";
      return Result.failure(message);
    }

    ///Проверяем, что приложение Tinkoff Bank доступно
    final bool isAvailable = await _tinkoffId.isTinkoffAuthAvailable();
    if (!isAvailable) {
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffApp,
        step: MetricStep.begin,
        status: MetricStatus.error,
        error: "Приложение Банка Tinkoff не установлено у пользователя или не определено",
      );
      return Result.failure("Приложение TinkoffBank не найдено или не установлено");
    }
    _metricUseCase.send(
      authType: MetricAuthType.tinkoffApp,
      step: MetricStep.begin,
      status: MetricStatus.success,
    );

    ///Начинаем слушать первую входящую ссылку из приложения тиньков, не ждём
    final appLinkFuture = AppLinks().stringLinkStream.first;

    ///Запускаем приложение Tinkoff Bank
    await _tinkoffId.startTinkoffAuth(redirectUri);

    ///Дожидаемся первой входящей ссылки из приложения Tinkoff Bank
    late final String url;
    try {
      url = await appLinkFuture.timeout(seconds(120));
    } catch (e) {
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffApp,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.cancelledByUser,
        error: "За 120 секунд ожидания из приложения Tinkoff Bank не поступила входящая ссылка в приложение "
            "EveryLounge: пользователь закрыл приложение Tinkoff(отменил вход), или находился в нём в течение "
            "120 секунд, ничего не делая",
      );
      return Result.failure("Вход через Tinkoff ID отменён");
    }

    ///Получаем токен из входящей ссылки
    late final TokenPayload payload;
    try {
      payload = await _tinkoffId.getTokenPayload(url);
    } on PlatformException catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.tinkoffApp,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "startTinkoffFuture throw: ${e.toString()}",
      );
      Log.exception(e, s, "startTinkoffFuture");
      return Result.failure("Не удалось получить токен из приложения Tinkoff Bank: ${e.message!}", e);
    }

    ///Обмениваем социальный токен на токен Everylounge
    final result = await _signInWithSocialTokenUseCase.signIn(
      SocialAuthType.tinkoffApp,
      payload.accessToken,
      tinkoffRefreshToken: payload.refreshToken,
    );

    /// Обновляем данные о проходах
    try {
      await _tinkoffPassUseCase.getPassageInfo(payload.accessToken);
    } catch (e, s) {
      Log.exception(e, s, "Не удалось получить данные о проходах Тинькофф");
    }

    ///Возращаем полученный набор токенов
    return result;
  }
}
