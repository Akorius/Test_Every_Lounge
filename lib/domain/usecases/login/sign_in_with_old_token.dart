import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/old_tokens.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';

abstract class SignInWithOldTokenUseCase {
  Future<Result<EveryLoungeToken>> signIn();
}

class SignInWithOldTokenUseCaseImpl implements SignInWithOldTokenUseCase {
  final LoginApi _loginApi = getIt();
  final TokensStorage _tokensStorage = getIt();
  final OldTokensStorage _oldTokensStorage = getIt();
  final GetUserUseCase _getUserUseCase = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn() async {
    ///Получаем старый токен из старого хранилища
    late final String? oldAccessToken;
    late final String? oldTinkoffRefreshToken;
    try {
      oldAccessToken = _oldTokensStorage.accessToken;
      oldTinkoffRefreshToken = _oldTokensStorage.tinkoffRefreshToken;
    } catch (e, s) {
      Log.exception(e, s, "SignInWithOldToken");
      return Result.failure("Не удалось получить токен доступа из старого хранилища.");
    }

    ///Если токен == null, выходим
    if (oldAccessToken == null) {
      return Result.failure("Старого токена в хранилище не оказалось.");
    }

    ///Получаем новый токен в обмен на старый
    late final EveryLoungeToken tokenPayload;
    try {
      tokenPayload = await _loginApi.oldUserLogin(oldAccessToken);
    } catch (e, s) {
      Log.exception(e, s, "SignInWithOldToken");
      return Result.failure("Не удалось получить новый токен доступа из системы EveryLounge.");
    }

    ///Сохраняем новый токен в новое хранилище, сохраняем старый рефреш токен в новое хранилище
    try {
      _tokensStorage.accessToken = tokenPayload.accessToken;
      _tokensStorage.refreshToken = tokenPayload.refreshToken;
      _tokensStorage.tinkoffRefreshToken = oldTinkoffRefreshToken;
    } catch (e, s) {
      Log.exception(e, s, "SignInWithOldToken");
      return Result.failure("Не удалось сохранить новый токен в новое хранилище");
    }

    ///В случае успеха затираем старые токены в старом хранилище
    try {
      _oldTokensStorage.accessToken = null;
      _oldTokensStorage.tinkoffRefreshToken = null;
    } catch (e, s) {
      Log.exception(e, s, "SignInWithOldToken");
      return Result.failure("Не удалось удалить старые токены в старом хранилище.");
    }

    ///Получаем пользователя по новому токену, cохраняем нового пользователя в хранилище
    final result = await _getUserUseCase.get();
    if (!result.isSuccess) {
      return Result.failure(result.message);
    }

    ///Выходим с успехом
    return Result.success(tokenPayload);
  }
}
