import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class DeleteUserUseCase {
  Future<Result<bool>> deleteUser({required String? email, String? code});
}

class DeleteUserUseCaseImpl implements DeleteUserUseCase {
  final LoginApi _loginApi = getIt();

  @override
  Future<Result<bool>> deleteUser({required String? email, String? code}) async {
    try {
      await _loginApi.deleteProfile(email: email, code: code);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "DeleteUserUseCaseImpl");
      return Result.failure("Не удалось удалить аккаунт.");
    }
  }
}
