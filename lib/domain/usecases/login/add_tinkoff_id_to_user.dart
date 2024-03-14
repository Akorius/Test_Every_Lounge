import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';

abstract class AddTinkoffIdToUserUseCase {
  Future<Result<User>> add(String tinkoffAccessToken, String tinkoffRefreshToken);
}

class AddTinkoffIdToUserUseCaseImpl implements AddTinkoffIdToUserUseCase {
  final LoginApi _loginApi = getIt();
  final TokensStorage _tokensStorage = getIt();

  @override
  Future<Result<User>> add(String tinkoffAccessToken, String tinkoffRefreshToken) async {
    final User addResult;

    try {
      addResult = await _loginApi.addTinkoffIdToUser(tinkoffAccessToken);
      _tokensStorage.tinkoffRefreshToken = tinkoffRefreshToken;
    } catch (e, s) {
      Log.exception(e, s, "AddTinkoffIdToUserUseCaseImpl");
      const message = "Не удалось добавить пользователя TinkoffBank к пользователю EveryLounge.";
      return Result.failure(message);
    }

    return Result.success(addResult);
  }
}
