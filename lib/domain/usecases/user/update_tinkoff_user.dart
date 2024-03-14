import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/usecases/user/log_out.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:tinkoff_id_flutter/entities/token_payload.dart';
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

abstract class UpdateTinkoffUserUseCase {
  Future<Result<String>> update();
}

class UpdateTinkoffUserUseCaseImpl implements UpdateTinkoffUserUseCase {
  final TokensStorage _tokensStorage = getIt();
  final UserStorage _userStorage = getIt();
  final TinkoffIdFlutter _tinkoffIdFlutter = getIt();
  final LogOutUserUseCase _logOutUserUseCase = getIt();
  final LoginApi _loginApi = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  @override
  Future<Result<String>> update() async {
    final tinkoffId = _userStorage.tinkoffId;
    final authType = _userStorage.authType;

    ///Логируем поломанного пользователя
    if (authType == AuthType.tinkoff && tinkoffId == null) {
      Log.message("$authType == AuthType.tinkoff && $tinkoffId == null", sender: "UpdateTinkoffUserUseCaseImpl");
    }

    if (PlatformWrap.isWeb) {
      return Result.failure("Обновление рефреш токена тинькофф не произведено в веб версии");
    }

    ///Если пользователь не является тинькофф то выходим
    if (tinkoffId == null && authType != AuthType.tinkoff) {
      return Result.failure("Обновление рефреш токена тинькофф не произведено для нетинькофф пользователя.");
    }

    ///Если рефреш токена тинькоф не оказалось в хранилище, то выходим, но не производим разлогин
    final refreshToken = _tokensStorage.tinkoffRefreshToken;
    if (refreshToken == null) {
      return Result.failure("Не удалось обновить информацию о пользователе Тинькофф.");
    }

    /// Обновляем токен тинькова по рефреш токену
    late final TokenPayload tokenPayload;
    try {
      tokenPayload = await _tinkoffIdFlutter.updateToken(refreshToken);
    } catch (e, s) {
      if (e is DioError && e.response?.statusCode == 401) {
        // разлогиним если не правильный токен
      } else {
        Log.exception(e, s, "UpdateTinkoffUserUseCaseImpl");
      }
      await _logOutUserUseCase.logOut();
      return Result.failure("Не удалось обновить токен тинькоф по рефреш токену.");
    }

    /// Сохраняем новый рефреш токен тинькофф в хранилище
    try {
      _tokensStorage.tinkoffRefreshToken = tokenPayload.refreshToken;
    } catch (e, s) {
      Log.exception(e, s, "UpdateTinkoffUserUseCaseImpl");
      return Result.failure("Не удалось сохранить новый рефреш токен Тинькофф");
    }

    /// Передаём новый access токен тинькофф на наш бэкенд для обновления пользователя
    try {
      await _loginApi.updateTinkoffUser(tokenPayload.accessToken);
    } catch (e, s) {
      Log.exception(e, s, "UpdateTinkoffUserUseCaseImpl");
      await _logOutUserUseCase.logOut();
      return Result.failure("Не удалось сохранить новый рефреш токен Тинькофф");
    }

    _tokensStorage.tinkoffAccessToken = tokenPayload.accessToken;

    /// Обновляем данные о проходах
    try {
      await _tinkoffPassUseCase.getPassageInfo(tokenPayload.accessToken);
    } catch (e, s) {
      Log.exception(e, s, "Не удалось получить данные о проходах Тинькофф");
    }

    return Result.success("message");
  }
}
