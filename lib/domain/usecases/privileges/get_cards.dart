import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/data/storages/card.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/domain/usecases/privileges/synchronize_cards.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:everylounge/domain/usecases/user/update_user.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetCardsUseCase {
  ///Получаем карты из апи
  ///Подставляем фейковую карту
  ///Сохраняем карту в хранилище
  ///Добавляем карты в стриму
  Future<Result<List<BankCard>>> get();

  ///
  Stream<List<BankCard>> get stream;

  Future<Result<BankCard>> active({bool notFake = false});
}

class GetCardsUseCaseImplMock implements GetCardsUseCase {
  final BehaviorSubject<List<BankCard>> _cardsController = BehaviorSubject();

  @override
  Future<Result<BankCard>> active({bool notFake = false}) async {
    return Result.success(BankCard.mock());
  }

  @override
  Future<Result<List<BankCard>>> get() async {
    return Result.success([]);
  }

  @override
  Stream<List<BankCard>> get stream => _cardsController.stream;
}

class GetCardsUseCaseImpl implements GetCardsUseCase {
  final UserStorage _userStorage = getIt();
  final CardStorage _cardStorage = getIt();
  final PrivilegesApi _cardApi = getIt();
  final SynchronizeCardsInMagazineAndBackendUseCase _synchronizeCardsInMagazineAndBackendUseCase = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final UpdateUserUseCase _updateUserUseCase = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();

  final BehaviorSubject<List<BankCard>> _cardsController = BehaviorSubject();

  @override
  Future<Result<List<BankCard>>> get() async {
    ///Синхронизируем карты
    await _synchronizeCardsInMagazineAndBackendUseCase.synchronize();

    ///Получаем карты из апи
    late final List<BankCard> cards;
    try {
      cards = await _cardApi.getCards();
      // cards = [];
    } catch (e, s) {
      Log.exception(e, s, "GetCardsUseCaseImpl");
      return Result.failure("Не удалось получить список карт.");
    }

    await updateUser();

    addTinkoff(cards);
    addAlfa(cards);
    addCardsByPassage(cards);
    sortCards(cards);

    ///Сохраняем карту в хранилище
    try {
      _cardStorage.cards = cards;
    } catch (e, s) {
      Log.exception(e, s, "GetCardsUseCaseImpl");
      return Result.failure("Ошибка сохранения карт в хранилище.");
    }

    ///Добавляем карты в стриму
    _cardsController.add(cards);
    return Result.success(cards);
  }

  Future<void> updateUser() async {
    var result = await _getUserUseCase.get();
    if (result.isSuccess) {
      var user = result.value;

      ///меняем имя пользователя если это альфа-клуб и имя в профиле пустое
      if (user.activeBank == ActiveBank.alfa &&
          user.activePassage?.firstName?.isNotEmpty == true &&
          user.activePassage?.lastName?.isNotEmpty == true &&
          user.profile.firstName.isEmpty &&
          user.profile.lastName.isEmpty) {
        await _updateUserUseCase.update(firstName: user.activePassage?.firstName, lastName: user.activePassage?.lastName);
        await _getUserUseCase.get();
      }
    }
  }

  void sortCards(List<BankCard> cards) {
    ///Сортируем - первая карта активная
    cards.sort((a, b) {
      if (a.isActive) {
        return -1;
      } else {
        return 1;
      }
    });
  }

  void addCardsByPassage(List<BankCard> cards) {
    ///Подставляем карты на основе банковских программ, добавленных по номеру телефона
    final passages = _userStorage.passages;
    passages.add(Passage.mock());
    final user = _userStorage.user;
    for (final passage in passages) {
      cards.insert(0, BankCard.phoneFakeFromProfile(passage, passage.bank == user?.activePassage?.bank));
    }
  }

  void addTinkoff(List<BankCard> cards) {
    ///Подставляем фейковую карту Тинькофф, если нужно
    final tinkoffId = _userStorage.tinkoffId;
    final tinkoffIsActive = _userStorage.user?.activeBank == ActiveBank.tinkoff;
    final tinkoffBankStatus = _userStorage.tinkoffBankStatus;
    if (tinkoffId != null && tinkoffBankStatus != null) {
      var info = _tinkoffPassUseCase.passage?.counterInfo;
      int? passCount = info?.isInfinity == true ? -1 : info?.count;
      cards.insert(0, BankCard.tinkoffFakeFromProfile(tinkoffBankStatus, tinkoffIsActive, passCount));
    }
  }

  void addAlfa(List<BankCard> cards) {
    ///Подставляем фейковую карту Alfa, если нужно
    final alfaId = _userStorage.alfaId;
    final alfaIsActive = _userStorage.user?.activeBank == ActiveBank.alfa;
    final alfaBankStatus = _userStorage.alfaBankStatus;
    var alfaPassage = _userStorage.passages.firstWhereOrNull((element) => element.bank == ActiveBank.alfa);

    /// добавим карту альфаПремиум, если есть альфа id и нет в списке passage альфы(т.е. не альфа-клуб)
    if (alfaId != null && alfaBankStatus != null && alfaPassage == null) {
      cards.insert(0, BankCard.alfaFakeFromProfile(alfaBankStatus, alfaIsActive));
    }
  }

  @override
  Stream<List<BankCard>> get stream {
    final cards = _cardStorage.cards;
    if (cards != null) {
      _cardsController.add(cards);
    } else {
      get();
    }
    return _cardsController.stream;
  }

  @override
  Future<Result<BankCard>> active({bool notFake = false}) => stream.first.then((value) {
        try {
          if (notFake) {
            return Result.success(value.firstWhere((element) => element.isActive && !(element.fake ?? false)));
          } else {
            return Result.success(value.firstWhere((element) => element.isActive));
          }
        } catch (e) {
          return Result.failure("Нет активной привязанной карты.");
        }
      });
}
