import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_identifier.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';
import 'package:everylounge/domain/usecases/privileges/get_bins.dart';
import 'package:flutter/services.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';
import 'package:tinkoff_acquiring_native_flutter/tinkoff_acquiring_native_flutter.dart' as n;

import 'synchronize_cards.dart';

abstract class AttachCardUseCase {
  Future<Result<BankCard>> attach();
}

/// 1. Сихронизировать карты в магазине и на бэкенде
/// 2. Привязать карту
/// 3. Обновить список карт в локальном хранилище, у которого есть слушатели
class AttachCardUseCaseImpl implements AttachCardUseCase {
  final InitAcquiringUseCase _initAcquiringUseCase = getIt();
  final UserStorage _userStorage = getIt();
  final n.TinkoffAcquiring _tinkoffAcquiringNative = getIt();
  TinkoffAcquiring? _tinkoffAcquiringApi;
  final GetBinsUseCase _getBinsUseCase = getIt();
  final PrivilegesApi _cardApi = getIt();
  final BankCardIdentifier _bankCardIdentifier = getIt();
  final SynchronizeCardsInMagazineAndBackendUseCase _synchronizeCardsInMagazineAndBackendUseCase = getIt();

  @override
  Future<Result<BankCard>> attach() async {
    await _synchronizeCardsInMagazineAndBackendUseCase.synchronize();

    ///Инициализируем нативную реализацию и апи реализацию с помощью магазина для привязки карты
    final initResult = await _initAcquiringUseCase.init(shop: ClientShop.attachCard);
    if (!initResult.isSuccess) {
      return Result.failure(initResult.message);
    }
    _tinkoffAcquiringApi = initResult.value;
    final initNative = await _initAcquiringUseCase.initNative(shop: ClientShop.attachCard);
    if (!initNative.isSuccess) {
      return Result.failure(initResult.message);
    }

    ///Проверяем, есть ли у пользователя id
    final customerKey = _userStorage.id.toString();
    if (customerKey.isEmpty) {
      const message =
          "Не удалось получить идентификатор пользователя в системе Every Lounge. Попробуйте войти в приложение заново.";
      Log.exception(Exception(message), null, "attachCard");
      return Result.failure(message);
    }

    ///Проверяем, есть ли у пользователя email
    final email = _userStorage.email;
    if (email.isEmpty) {
      const message = "Не удалось получить email пользователя. Попробуйте войти в приложение снова.";
      Log.exception(Exception(message), null, "attachCard");
      return Result.failure(message);
    }

    ///Обновляем бины с бэка
    await _getBinsUseCase.get();

    /// Получаем бины которые были сохранены при старте приложения
    final binList = await _getBinsUseCase.stream.first;
    if (binList.isEmpty) {
      _getBinsUseCase.get();
      const message = "Не получилось получить список банков участвующих в программе. Попробуйте снова";
      Log.exception(
        Exception(message),
        null,
        "binList",
      );
      return Result.failure(message);
    }

    ///Показываем нативную штору и ждём результат, результат: или PlatformException или [cardId]
    late final List attachResult;
    try {
      attachResult = await _tinkoffAcquiringNative.attachCardWithNativeScreen(customerKey: customerKey, email: email);
    } on PlatformException catch (e) {
      return Result.failure(e.message.toString());
    }

    ///Получаем информацию о карте, которую только что привязали в магазин
    final String attachedCardId = attachResult[0]; //rebillId из SDK не получается получить, хотя в ответе есть

    late final GetCardListResponse cardListResponse;
    try {
      cardListResponse = await _tinkoffAcquiringApi!.getCardList(GetCardListRequest(customerKey: customerKey));
    } catch (e, s) {
      const message = "Не удалось получить список привязанных карт";
      Log.exception(e, s, "attachCardWithNativeScreen");
      return Result.failure("$message: ${e.toString()}");
    }
    if (cardListResponse.success == false) {
      const message = "Не удалось получить список привязанных карт";
      Log.exception(Exception(message), null, "attachCardWithNativeScreen");
      return Result.failure(message);
    }
    final attachedCard = cardListResponse.cardInfo!.firstWhere((element) => element.cardId == attachedCardId);

    ///Выясняем программу карты и количество бесплатных проходов
    final identificationResult = _bankCardIdentifier.identify(attachedCard.pan!.substring(0, 6), binList);

    ///Проверяем наличие rebillId
    late final int rebillId;
    try {
      rebillId = int.parse(attachedCard.rebillId!);
    } catch (e, s) {
      Log.exception(Exception("rebillId карты пришёл с магазина равный null"), s, "rebillId = int.parse");
      return Result.failure("Не удалось привязать карту из-за отсутствия идентификатора рекуррентного платежа в магазине.");
    }
    final cardToAdd = BankCard(
      id: 0,
      createdAt: "0",
      updatedAt: "0",
      sdkId: attachedCardId,
      maskedNumber: attachedCard.pan!,
      isActive: true,
      type: identificationResult.cardType,
      selfPasses: identificationResult.freeSelfPassesCount,
      guestPasses: identificationResult.freeGuestsPassesCount,
      rebillId: rebillId,
    );
    try {
      await _cardApi.addCard(cardToAdd);
    } on DioError catch (e, s) {
      /// Если код ответа от бэкенда 409 сообщаем пользователю, что данная карта уже существует
      if (e.response?.statusCode == 409) {
        Log.exception(e, s, "addCard");
        return Result.failure("Данная карта уже существует в системе Every Lounge");
      }
      rethrow;
    } catch (e, s) {
      /// Если не получилось привязать карту в бэкенд выводим соообщение пользователю и выходим
      Log.exception(e, s, "addCard");
      return Result.failure("Не удалось привязать карту в систему Every Lounge");
    }
    return Result.success(cardToAdd);
  }
}
