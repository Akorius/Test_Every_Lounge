import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetUserUseCase {
  ///Получаем пользователя через API
  ///Сохраняем в хранилище
  ///Передаём с поток
  Future<Result<User>> get();

  ///Получаем поток пользователя, где гарантированно есть локально сохранённый пользователь
  Stream<User> get stream;
}

class GetUserUseCaseImplMock implements GetUserUseCase {
  final BehaviorSubject<User> _userController = BehaviorSubject();

  @override
  Future<Result<User>> get() async {
    return Result.success(User.mock());
  }

  @override
  Stream<User> get stream => _userController.stream;
}

class GetUserUseCaseImpl implements GetUserUseCase {
  final LoginApi _loginApi = getIt();
  final UserStorage _storage = getIt();
  final BehaviorSubject<User> _userController = BehaviorSubject();

  @override
  Future<Result<User>> get() async {
    ///Получаем пользователя через API
    late final User user;
    try {
      user = await _loginApi.userMe();
    } catch (e, s) {
      Log.exception(e, s, "userMe");
      return Result.failure("Не удалось получить информацию о вашем профиле. Попробуйте позднее.");
    }

    /// Сохраняем пользователя локально
    try {
      _storage.user = user;
    } catch (e, s) {
      Log.exception(e, s, "userMe");
      return Result.failure("Не удалось сохранить профиль в базу данных. Попробуйте позднее.");
    }

    /// Добавляем пользователя в поток
    _userController.add(user);
    return Result.success(user);
  }

  @override
  Stream<User> get stream {
    final localUser = _storage.user;
    if (localUser != null) {
      _userController.add(localUser);
    } else {
      get();
    }
    return _userController.stream;
  }
}
