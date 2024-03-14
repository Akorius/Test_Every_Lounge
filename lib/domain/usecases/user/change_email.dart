import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';

abstract class ChangeEmailUseCase {
  Future<Result<bool>> requestEmailChange({String email = "", bool resend = false});

  Future<Result<bool>> confirmCode({
    required String code,
  });

  bool needSetEmail();
}

class ChangeEmailUseCaseImpl implements ChangeEmailUseCase {
  final LoginApi _loginApi = getIt();
  final UserStorage _userStorage = getIt();

  String _email = "";

  @override
  Future<Result<bool>> requestEmailChange({String email = "", bool resend = false}) async {
    if (resend) {
      email = _email;
    } else {
      _email = email;
    }
    try {
      await _loginApi.changeEmail(email: _email);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "ChangeEmailUseCaseImpl");
      return Result.failure("Аккаунт с такой почтой уже существует. Укажите другую почту или авторизуйтесь через email");
    }
  }

  @override
  Future<Result<bool>> confirmCode({
    required String code,
  }) async {
    try {
      await _loginApi.changeEmailCode(email: _email, code: code);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "ChangeEmailUseCaseImpl");
      return Result.failure("Не удалось поменять email.");
    }
  }

  @override
  bool needSetEmail() {
    return _userStorage.authType != AuthType.anon && _userStorage.email.isEmpty;
  }
}
