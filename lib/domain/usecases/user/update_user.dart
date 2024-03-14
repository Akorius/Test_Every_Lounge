import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class UpdateUserUseCase {
  Future<Result<bool>> update({String? phone, String? firstName, String? lastName, int? avatarId, int? rateFlag});
}

class UpdateUserUseCaseImpl implements UpdateUserUseCase {
  final LoginApi _loginApi = getIt();

  @override
  Future<Result<bool>> update({String? phone, String? firstName, String? lastName, int? avatarId, int? rateFlag}) async {
    try {
      await _loginApi.updateMe(phone, firstName, lastName, avatarId, rateFlag);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "UpdateUserUseCaseImpl");
      return Result.failure("Не удалось обновить пользователя.");
    }
  }
}
