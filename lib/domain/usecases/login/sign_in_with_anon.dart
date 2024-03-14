import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/auth_provider.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';

abstract class SignInWithAnonUseCase {
  Future<Result<EveryLoungeToken>> signIn();
}

class SignInWithAnonUseCaseImpl implements SignInWithAnonUseCase {
  final LoginApi _loginApi = getIt();
  final TokensStorage _tokensStorage = getIt();
  final GetUserUseCase _getUserUseCase = getIt();

  @override
  Future<Result<EveryLoungeToken>> signIn() async {
    ///Выходим, если анонимный или токен пользователя существует
    if (_tokensStorage.accessToken != null) return Result.failure("Токен пользователя или анонимный токен уже существует.");

    ///Получаем анонимный токен
    late final EveryLoungeToken token;
    try {
      token = await _loginApi.social(provider: AuthProvider.anon);
    } catch (e, s) {
      Log.exception(e, s, "login with anon");
      return Result.failure("Не удалось войти анонимно.");
    }

    ///Сохраняем токены
    try {
      _tokensStorage.accessToken = token.accessToken;
      _tokensStorage.refreshToken = token.refreshToken;
    } catch (e, s) {
      Log.exception(e, s, "login with anon");
      return Result.failure("Не удалось сохранить анонимные токены.");
    }

    ///Получаем пользователя
    final result = await _getUserUseCase.get();

    if (!result.isSuccess) {
      return Result.failure(result.message);
    }
    return Result.success(token);
  }
}
