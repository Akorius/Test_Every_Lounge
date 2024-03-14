import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

abstract class AddTinkoffIdToUserWebUseCase {
  ///Проверяем, что clientIdTinkoffId и mobileRedirectUri были успешно получены
  ///Отслыаем метрики
  Future<Result> launchWebView();

  ///Обрабатываем результат, который завершился с ошибкой
  ///Возвращаем токены обратно в случае успеха
  Future<Result<User>> addWithWebViewResult(TinkoffIdResult? result);
}

class AddTinkoffIdToUserWebUseCaseImpl implements AddTinkoffIdToUserWebUseCase {
  final RemoteConfigStorage _remoteStorage = getIt();
  final AddTinkoffIdToUserUseCase _addTinkoffIdToUserUseCase = getIt();

  @override
  Future<Result> launchWebView() async {
    ///Проверяем, что clientIdTinkoffId и mobileRedirectUri были успешно получены
    final clientId = _remoteStorage.tinkoffIdClientId;
    final redirectUri = _remoteStorage.tinkoffIdRedirectUri;
    if (clientId.isEmpty || redirectUri.isEmpty) {
      final message = "clientId: $clientId или mobileRedirectUri: $redirectUri пустая строка";
      Log.exception(message, null, "generateUriForTinkoffIdWeb");
      return Result.failure("Не удалось получить информацию о поставщике входа");
    }
    return Result.success(true);
  }

  @override
  Future<Result<User>> addWithWebViewResult(TinkoffIdResult? result) async {
    ///Обрабатываем результат, который завершился с ошибкой
    if (!(result?.isSuccess ?? false)) {
      final String message;
      switch (result?.failureValue) {
        case null:
        case TinkoffIdFailure.cancelledByUser:
          message = "Вход отменён пользователем";
          break;
        case TinkoffIdFailure.webResourceError:
        case TinkoffIdFailure.noCodeInRedirectUri:
        case TinkoffIdFailure.apiCallError:
          Log.exception(Exception(result!.message), null, "processWebViewResult");
          message = result.message;
          break;
      }
      return Result.failure(message, result?.failureValue ?? TinkoffIdFailure.cancelledByUser);
    }

    ///Обмениваем социальный токен на токен Everylounge
    final resultSignIn = await _addTinkoffIdToUserUseCase.add(
      result!.tokenPayload.accessToken,
      result.tokenPayload.refreshToken,
    );

    ///Возвращаем пользователя
    return resultSignIn;
  }
}
