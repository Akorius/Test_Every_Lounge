import 'package:app_links/app_links.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/usecases/login/add_tinkoff_id_to_user.dart';
import 'package:flutter/services.dart';
import 'package:tinkoff_id_flutter/entities/token_payload.dart';
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

abstract class AddTinkoffIdToUserSDKUseCase {
  ///Получаем [redirectUri]
  ///Проверяем, что приложение Tinkoff Bank доступно
  ///Начинаем слушать первую входящую ссылку из приложения тиньков, не ждём
  ///Запускаем приложение Tinkoff Bank
  ///Дожидаемся первой входящей ссылки из приложения Tinkoff Bank
  ///Получаем токен из входящей ссылки
  ///Обмениваем социальный токен на обновленного пользователя
  ///Возращаем полученный набор токенов
  Future<Result<User>> add();
}

class AddTinkoffIdToUserSDKUseCaseImpl implements AddTinkoffIdToUserSDKUseCase {
  final TinkoffIdFlutter _tinkoffId = getIt();
  final RemoteConfigStorage _remoteStorage = getIt();
  final AddTinkoffIdToUserUseCase _addTinkoffIdToUserUseCase = getIt();

  @override
  Future<Result<User>> add() async {
    ///Получаем [redirectUri]  из удалённого хранилища
    final redirectUri = _remoteStorage.tinkoffIdRedirectUri;
    if (redirectUri.isEmpty) {
      Log.exception(Exception("redirectUri: $redirectUri. Строка пустая."));
      const message = "Не удалось получить информацию о поставщике входа";
      return Result.failure(message);
    }

    ///Проверяем, что приложение Tinkoff Bank доступно
    final bool isAvailable = await _tinkoffId.isTinkoffAuthAvailable();
    if (!isAvailable) {
      return Result.failure("Приложение TinkoffBank не найдено или не установлено");
    }

    ///Начинаем слушать первую входящую ссылку из приложения тиньков, не ждём
    final appLinkFuture = AppLinks().stringLinkStream.first;

    ///Запускаем приложение Tinkoff Bank
    await _tinkoffId.startTinkoffAuth(redirectUri);

    ///Дожидаемся первой входящей ссылки из приложения Tinkoff Bank
    late final String url;
    try {
      url = await appLinkFuture.timeout(seconds(120));
    } catch (e) {
      return Result.failure("Вход через Tinkoff ID отменён");
    }

    ///Получаем токен из входящей ссылки
    late final TokenPayload payload;
    try {
      payload = await _tinkoffId.getTokenPayload(url);
    } on PlatformException catch (e, s) {
      Log.exception(e, s, "startTinkoffFuture");
      return Result.failure("Не удалось получить токен из приложения Tinkoff Bank: ${e.message!}", e);
    }

    ///Обмениваем социальный токен на обновленного пользователя
    final addResult = await _addTinkoffIdToUserUseCase.add(payload.accessToken, payload.refreshToken);

    if (!addResult.isSuccess) {
      return Result.failure(addResult.message);
    }

    ///Возращаем юзера
    return addResult;
  }
}
