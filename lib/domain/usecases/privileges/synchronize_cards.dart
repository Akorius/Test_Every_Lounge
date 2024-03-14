import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';

///Cинхронизация: удаление лишних карт на бэке и в магазине
abstract class SynchronizeCardsInMagazineAndBackendUseCase {
  Future<Result<String>> synchronize();
}

///Cинхронизация: удаление лишних карт на бэке и в магазине
class SynchronizeCardsInMagazineAndBackendUseCaseImpl implements SynchronizeCardsInMagazineAndBackendUseCase {
  final UserStorage _userStorage = getIt();
  TinkoffAcquiring? _tinkoffAcquiringApi;
  final InitAcquiringUseCase _initAcquiringUseCase = getIt();
  final PrivilegesApi _cardApi = getIt();

  @override
  Future<Result<String>> synchronize() async {
    ///Успешно выходим из метода, если пользователь анонимный
    if ([AuthType.anon].contains(_userStorage.authType)) {
      return Result.success("Синхронизация карт не проведена для анонимного пользователя");
    }

    final initAcquiringResult = await _initAcquiringUseCase.init(shop: ClientShop.attachCard);
    if (!initAcquiringResult.isSuccess) {
      return Result.failure(initAcquiringResult.message);
    }
    _tinkoffAcquiringApi = initAcquiringResult.value;

    ///Получаем customerKey из хранилища
    final customerKey = _userStorage.id.toString();

    ///Выходим из метода, если в базе данных нет id пользователя, он же customerKey в магазине
    if (customerKey.isEmpty) {
      const message = "Не удалось получить идентификатор пользователя. Попробуйте войти в приложение заново";
      Log.exception(Exception(message), null, "synchronizeCardsInMagazineAndBackend");
      return Result.failure(message);
    }

    ///Получаем список карт в магазине
    late final GetCardListResponse cardListFromMagazineResponse;
    try {
      cardListFromMagazineResponse = await _tinkoffAcquiringApi!.getCardList(GetCardListRequest(customerKey: customerKey));
    } catch (e, s) {
      Log.exception(e, s, "sender");
      return Result.failure("Не удалось получить список карт в магазине.");
    }

    /// не проверяем успешность запроса, потому что всегда success == null в случае успеха, про неуспех неизвестно
    if (cardListFromMagazineResponse.success == false) {
      final message = cardListFromMagazineResponse.message ??
          cardListFromMagazineResponse.details ??
          "Ошибка запроса получения списка карт в магазине";
      if (!message.contains("Неверный статус покупателя")) {
        Log.exception(Exception(message), null, "synchronizeCardsInMagazineAndBackend");
      }

      return Result.failure(message);
    }

    ///Получаем список карт c бэкенда
    late final List<BankCard> backendCardList;
    try {
      backendCardList = await _cardApi.getCards();
    } catch (e, s) {
      Log.exception(e, s, "synchronizeCardsInMagazineAndBackend");
      return Result.failure("Не удалось получить список карт пользователя в системе Every Lounge");
    }

    ///Создаём уникальное множество id карт в магазине, которые нужно удалить
    final cardIdsToDeleteInMagazine = <String>{};

    /// Добавляем для удаления карты:
    /// -которые есть в магазине, но нет на бэкенде
    /// -у которых нет rebillId
    /// -игнорируем удалённые карты
    final backendCardIds = backendCardList.map((e) => e.sdkId);
    for (final magazineCard in cardListFromMagazineResponse.cardInfo!) {
      if (magazineCard.status == CardStatus.deleted) continue;
      if (magazineCard.rebillId == null) {
        cardIdsToDeleteInMagazine.add(magazineCard.cardId!);
        continue;
      }
      if (!backendCardIds.contains(magazineCard.cardId)) {
        cardIdsToDeleteInMagazine.add(magazineCard.cardId!);
        continue;
      }
    }

    ///Формируем задания на удаление с магазина для быстроты, они уже начинают выполняться
    final magazineFutures = cardIdsToDeleteInMagazine
        .map((e) => _tinkoffAcquiringApi!.removeCard(RemoveCardRequest(cardId: int.parse(e), customerKey: customerKey)));

    ///Создаём уникальное множество id карт с бэкенда, которые нужно удалить
    final cardIdsToDeleteInBackend = <String>{};

    /// Добавляем для удаления карты
    /// - которые есть на бэкенде, но нет в магазине
    /// - у которых нет rebillID
    final magazineCardIds =
        cardListFromMagazineResponse.cardInfo!.where((element) => element.status == CardStatus.active).map((e) => e.cardId!);
    for (final backendCard in backendCardList) {
      if (backendCard.rebillId == 0) {
        cardIdsToDeleteInBackend.add(backendCard.sdkId);
        continue;
      }
      if (!magazineCardIds.contains(backendCard.sdkId)) {
        cardIdsToDeleteInBackend.add(backendCard.sdkId);
        continue;
      }
    }

    ///Формируем задания на удаление с бэкенда, они начинают выполняться
    final backendFutures = cardIdsToDeleteInBackend
        .map((e) => _tinkoffAcquiringApi!.removeCard(RemoveCardRequest(cardId: int.parse(e), customerKey: customerKey)));

    ///Ждём успешного завершения всех запросов удаления с бэкенда и с магазина, сначала обрабатываем бэкенд
    try {
      final backendResults = await Future.wait(backendFutures);
      final failedBackendResults = backendResults.where((element) => element.success == false);
      final magazineResults = await Future.wait(magazineFutures);
      final failedMagazineResults = magazineResults.where((element) => element.success != true);
      if (failedBackendResults.isNotEmpty) throw Exception("Не удалось удалить карту на сервере");
      if (failedMagazineResults.isNotEmpty) throw Exception(failedMagazineResults.first.message);
    } catch (e, s) {
      Log.exception(e, s, "synchronizeCardsInMagazineAndBackend");
      return Result.failure(e.toString());
    }

    ///Выходим из метода с успехом
    return Result.success("success");
  }
}
