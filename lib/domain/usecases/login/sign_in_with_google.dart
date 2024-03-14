import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
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
import 'package:google_sign_in/google_sign_in.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithGoogleUseCase {
  ///Получаем пользователя google/запускаем процесс входа через библиотеку google
  ///Проверяем, что пользователь получен
  ///Получаем токен доступа пользователя в гугл, для дальнейшей передачи на бэк
  ///Проверяем, что accessToken получен и не пустой
  ///Проводим базовую аутентификацию на бэкенде и возвращаем результат
  Future<Result<EveryLoungeToken>> signIn();
}

class SignInWithGoogleUseCaseImpl implements SignInWithGoogleUseCase {
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final GoogleSignIn _googleSignIn = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocial = getIt();
  final MetricsUseCase _metrics = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn() async {
    _metricUseCase.send(
      authType: MetricAuthType.googleSignIn,
      step: MetricStep.begin,
      status: MetricStatus.success,
    );

    ///Получаем пользователя google/запускаем процесс входа через библиотеку google
    late final GoogleSignInAccount? user;
    try {
      user = await _googleSignIn.signIn();
    } catch (e, s) {
      Log.exception(e, s, "withGoogle");
      _metricUseCase.send(
        authType: MetricAuthType.googleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "_googleSignIn.signIn() throw ${e.toString()}",
      );
      return Result.failure("Не удалось выполнить вход, через аккаунт Google");
    }

    ///Проверяем, что пользователь получен
    if (user == null) {
      _metricUseCase.send(
        authType: MetricAuthType.googleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.cancelledByUser,
        error: "Google SignIn user == null. Скорее всего это отменённый пользователем вход",
      );
      Log.exception(Exception("Google SignIn user == null"), null);
      return Result.failure("Не удалось получить информацию о пользователе Google");
    }

    ///Получаем токен доступа пользователя в гугл, для дальнейшей передачи на бэк
    late final String? accessToken;
    try {
      accessToken = (await _googleSignIn.currentUser!.authentication).accessToken;
    } catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.googleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        socialToken: null,
        error: "_googleSignIn.currentUser!.authentication throw ${e.toString()}",
      );
      Log.exception(e, s, "withGoogle");
      return Result.failure("Не удалось получить токен пользователя Google");
    }

    ///Проверяем, что accessToken получен и не пустой
    if (accessToken == null || accessToken.isEmpty) {
      _metricUseCase.send(
        authType: MetricAuthType.googleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "Токен пользователя Google == null или пустой после входа: token == $accessToken",
      );
      Log.exception(Exception("Токен пользователя Google == null или пустой после входа: $accessToken"));
      return Result.failure("Не удалось получить токен пользователя Google");
    }

    ///Проводим базовую аутентификацию на бэкенде и возвращаем результат
    _metrics.sendEvent(event: eventName[googleAuthSuccess]!, type: MetricsEventType.message);
    return _signInWithSocial.signIn(SocialAuthType.google, accessToken);
  }
}
