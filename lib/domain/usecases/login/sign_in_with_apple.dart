import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/metrics/metric_status.dart';
import 'package:everylounge/domain/entities/metrics/metric_step.dart';
import 'package:everylounge/domain/entities/metrics/metric_subtype.dart';
import 'package:everylounge/domain/entities/social_auth_type.dart';
import 'package:everylounge/domain/usecases/metrics/send_sign_in_metric.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithAppleUseCase {
  ///Получаем пользователя google/запускаем процесс входа через библиотеку google
  ///Проверяем, что пользователь получен
  ///Получаем токен доступа пользователя в apple, для дальнейшей передачи на бэк
  ///Проверяем, что accessToken получен и не пустой
  ///Проводим базовую аутентификацию на бэкенде и возвращаем результат
  Future<Result<EveryLoungeToken>> signIn();
}

class SignInWithAppleUseCaseImpl implements SignInWithAppleUseCase {
  final SendSignInMetricUseCase _metricUseCase = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocial = getIt();
  final OAuthProvider _authProvider = getIt(instanceName: "apple");
  final FirebaseAuth _firebaseAuth = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn() async {
    ///Проверяем доступность входа через apple
    final bool appleSignInIsAvailable = await SignInWithApple.isAvailable();

    if (!appleSignInIsAvailable) {
      const message = "Вход через Apple недоступен.";
      _metricUseCase.send(
        authType: MetricAuthType.appleSignIn,
        step: MetricStep.begin,
        status: MetricStatus.error,
        error: message,
      );
      Log.exception(Exception(message), null, "signIn");
      return Result.failure("$message Попробуйте позднее");
    }
    _metricUseCase.send(
      authType: MetricAuthType.appleSignIn,
      step: MetricStep.begin,
      status: MetricStatus.success,
    );

    ///Получаем из Apple данные для входа
    late final AuthorizationCredentialAppleID appleIdCredentials;
    try {
      appleIdCredentials = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.fullName,
        AppleIDAuthorizationScopes.email,
      ]);
    } catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.appleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "SignInWithApple.getAppleIDCredential throw: ${e.toString()}",
      );
      Log.exception(e, s, "signIn");
      return Result.failure("Не удалось получить токен из AppleID.");
    }

    ///Входим через FirebaseAuth используя Apple ID credentials
    final credentials = _authProvider.credential(
      accessToken: appleIdCredentials.authorizationCode,
      idToken: appleIdCredentials.identityToken,
    );
    try {
      await _firebaseAuth.signInWithCredential(credentials);
    } catch (e, s) {
      _metricUseCase.send(
        authType: MetricAuthType.appleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "firebaseAuth.signInWithCredential(credential) throw: ${e.toString()}",
      );
      Log.exception(e, s, "signIn");
      return Result.failure("Не удалось получить токен из AppleID.");
    }

    /// Получаем пользователя
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _metricUseCase.send(
        authType: MetricAuthType.appleSignIn,
        step: MetricStep.tokenObtaining,
        status: MetricStatus.error,
        error: "firebaseUserCredential.user == null",
      );
      Log.exception(Exception("Firebase user == null"), null, "signIn");
      return Result.failure("Не удалось получить токен из AppleID.");
    }

    ///Меняем пользователю displayName, если получили displayName из apple
    final String? displayName = (appleIdCredentials.givenName == null && appleIdCredentials.familyName == null)
        ? null
        : "${appleIdCredentials.givenName ?? ""} ${appleIdCredentials.familyName ?? ""}".trim();
    if (displayName != null) {
      try {
        await user.updateDisplayName(displayName);
        await user.reload();
      } catch (e, s) {
        Log.exception(e, s, "SignInWithAppleUseCaseImpl");
        return Result.failure("Не удалось обновить имя пользователя.");
      }
    }

    ///Меняем пользователю email, если получили email из apple
    if (appleIdCredentials.email != null) {
      try {
        await user.updateEmail(appleIdCredentials.email!);
        await user.reload();
      } catch (e, s) {
        Log.exception(e, s, "SignInWithAppleUseCaseImpl");
        return Result.failure("Не удалось обновить email пользователя.");
      }
    }
    final String accessToken = user.uid;

    ///Продолжаем авторизацию с помощью полученного токена
    return _signInWithSocial.signIn(SocialAuthType.apple, accessToken);
  }
}
