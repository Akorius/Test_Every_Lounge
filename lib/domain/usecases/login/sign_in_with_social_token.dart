import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/auth_provider.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';
import 'package:everylounge/domain/entities/social_auth_type.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';

abstract class SignInWithSocialTokenUseCase {
  ///В зависимости от способа входа определяем какой подтип будет в метрике и какой провайдер будет в запросе
  ///Оповещаем бэкенд, что социальный токен был успешно добыт
  ///Получаем токен в обмен на токен социального входа
  ///Проверяем, что полученный токен не null и не пуст
  ///Удаляем старый токен нотификаций из firebase в случае успеха получения токена
  ///Сохраняем токены авторизации в локальное хранилище
  ///Получаем пользователя с новыми токенами, к которым имеют доступы интерцепторы
  ///Если вход через TinkoffId, то сохраняем refreshToken в базу данных
  ///Выходим с успешным значением: первый вход и непервый вход
  Future<Result<EveryLoungeToken>> signIn(
    SocialAuthType socialType,
    String socialToken, {
    String? tinkoffRefreshToken,
    String? alfaRefreshToken,
  });
}

class SignInWithSocialTokenUseCaseImpl implements SignInWithSocialTokenUseCase {
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final LoginApi _loginApi = getIt();
  final TokensStorage _tokensStorage = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final MetricsUseCase _metrics = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn(
    SocialAuthType socialType,
    String socialToken, {
    String? tinkoffRefreshToken,
    String? alfaRefreshToken,
  }) async {
    ///В зависимости от способа входа определяем какой подтип будет в метрике и какой провайдер будет в запросе
    late final MetricAuthType authType;
    late final AuthProvider provider;
    switch (socialType) {
      case SocialAuthType.tinkoffApp:
        authType = MetricAuthType.tinkoffApp;
        provider = AuthProvider.tinkoffId;
        break;
      case SocialAuthType.tinkoffWeb:
        authType = MetricAuthType.tinkoffWeb;
        provider = AuthProvider.tinkoffId;
        break;
      case SocialAuthType.google:
        authType = MetricAuthType.googleSignIn;
        provider = AuthProvider.google;
        break;
      case SocialAuthType.apple:
        authType = MetricAuthType.appleSignIn;
        provider = AuthProvider.apple;
        break;
      case SocialAuthType.tinkoffWebToWeb:
        authType = MetricAuthType.tinkoffWebToWeb;
        provider = AuthProvider.tinkoffIdWebToWeb;
        break;
      case SocialAuthType.alfaWeb:
        authType = MetricAuthType.alfaWeb;
        provider = AuthProvider.alfaWeb;
        break;
    }

    ///Оповещаем бэкенд, что социальный токен был успешно добыт
    _metricUseCase.send(
      authType: authType,
      step: MetricStep.tokenObtaining,
      status: MetricStatus.success,
      socialToken: socialToken,
    );

    ///Получаем токен в обмен на токен социального входа
    late final EveryLoungeToken tokenPayload;
    try {
      _metricUseCase.send(
        authType: authType,
        step: MetricStep.requestSending,
        status: MetricStatus.success,
        socialToken: socialToken,
      );
      tokenPayload = await _loginApi.social(provider: provider, socialToken: socialToken);
      _metricUseCase.send(
        authType: authType,
        step: MetricStep.gettingResponse,
        status: MetricStatus.success,
        socialToken: socialToken,
      );
    } catch (e) {
      String? error;
      if (e is DioError) {
        error = e.response.toString();
      }
      _metricUseCase.send(
        authType: authType,
        step: MetricStep.gettingResponse,
        status: MetricStatus.error,
        socialToken: socialToken,
        error: "api request error: \n ${e.toString()} \n $error",
      );
      Log.exception(e, null, "signIn-${authType.name}");
      const message = "Не получилось обменять социальный токен на токен Every Lounge";
      return Result.failure(message);
    }

    ///Проверяем, что полученный токен не null и не пуст
    if (tokenPayload.accessToken.isEmpty) {
      _metricUseCase.send(
        authType: authType,
        step: MetricStep.requestSending,
        status: MetricStatus.error,
        socialToken: socialToken,
        error: "accessToken.isEmpty",
      );
      Log.exception(Exception("accessToken.isEmpty"), null, "signIn");
      const message = "Не получилось обменять социальный токен на токен Every Lounge";
      return Result.failure(message);
    }

    // ///Удаляем старый токен нотификаций из firebase в случае успеха получения токена
    // await _fireBaseRepository.deleteToken();

    ///Сохраняем токены авторизации в локальное хранилище
    _tokensStorage.accessToken = tokenPayload.accessToken;
    _tokensStorage.refreshToken = tokenPayload.refreshToken;

    ///Получаем пользователя с новыми токенами, к которым имеют доступы интерцепторы
    final result = await _getUserUseCase.get();
    if (!result.isSuccess) {
      return Result.failure(result.message);
    }

    ///Если вход через TinkoffId, то сохраняем refreshToken в базу данных
    if (socialType == SocialAuthType.tinkoffApp || socialType == SocialAuthType.tinkoffWeb) {
      _tokensStorage.tinkoffAccessToken = socialToken;
      _tokensStorage.tinkoffRefreshToken = tinkoffRefreshToken;
      _metrics.sendEvent(event: eventName[tinkoffAuthSuccess]!, type: MetricsEventType.message);
    }

    ///Если вход через AlfaId, то сохраняем refreshToken в базу данных
    if (socialType == SocialAuthType.alfaWeb) {
      _tokensStorage.alfaRefreshToken = alfaRefreshToken;
      _metrics.sendEvent(event: eventName[alfaAuthSuccess]!, type: MetricsEventType.message);
    }

    ///Выходим с успешным значением: первый вход и непервый вход
    return Result.success(tokenPayload);
  }
}
