import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tinkoff_id_web_token_payload.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/social_auth_type.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:pkce/pkce.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sign_in_with_social_token.dart';

abstract class SignInWithTinkoffWebToWebUseCase {
  Result<Uri> createUri();

  Future<Result<EveryLoungeToken>> processCallbackUrl(String? url);
}

class SignInWithTinkoffWebToWebUseCaseImpl implements SignInWithTinkoffWebToWebUseCase {
  final RemoteConfigStorage _remoteStorage = getIt();
  final SignInWithSocialTokenUseCase _signInWithSocialTokenUseCase = getIt();
  final LoginApi _loginApi = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  @override
  Result<Uri> createUri() {
    final clientId = _remoteStorage.tinkoffIdClientIdWeb;
    final webRedirectUri = _remoteStorage.tinkoffIdRedirectUriWeb;
    if (clientId.isEmpty || webRedirectUri.isEmpty) {
      final message = "clientId: $clientId or webRedirectUri: $webRedirectUri is empty";
      Log.exception(Exception(message));
      return Result.failure("Не нашли ");
    }
    final pkcePair = PkcePair.generate(length: 64);

    final uri = Uri.https(
      "id.tinkoff.ru",
      "/auth/authorize",
      {
        "client_id": clientId,
        "redirect_uri": webRedirectUri,
        "state": pkcePair.codeVerifier,
        "response_type": "code",
      },
    );
    launchUrl(uri);
    return Result.success(uri);
  }

  @override
  Future<Result<EveryLoungeToken>> processCallbackUrl(String? code) async {
    if (code == null) {
      return Result.failure("Отсутствует код проверки");
    }

    late final TinkoffIdWebTokenPayload tokenPayload;
    try {
      tokenPayload = await _loginApi.changeCodeForTinkoffTokenWeb(
        code: code,
      );
    } catch (e, s) {
      Log.exception(e, s);
      return Result.failure("Не удалось получить токен TinkoffID.");
    }

    ///Обмениваем социальный токен на токен Everylounge
    final resultSignIn = await _signInWithSocialTokenUseCase.signIn(
      SocialAuthType.tinkoffWebToWeb,
      tokenPayload.accessToken,
      tinkoffRefreshToken: tokenPayload.refreshToken,
    );

    /// Обновляем данные о проходах
    try {
      await _tinkoffPassUseCase.getPassageInfo(tokenPayload.accessToken);
    } catch (e, s) {
      Log.exception(e, s, "Не удалось получить данные о проходах Тинькофф");
    }

    ///Возвращаем токены EveryLounge в случае успеха
    return resultSignIn;
  }
}
