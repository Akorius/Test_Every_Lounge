import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';
import 'package:everylounge/domain/entities/tinkoff_pass/tinkoff_passage.dart';
import 'package:everylounge/domain/usecases/lounge/check_aa_health.dart';
import 'package:everylounge/domain/usecases/order/check_passage.dart';
import 'package:everylounge/domain/usecases/order/create_order.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/domain/usecases/payment/pay_with_pass.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/translit.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_alfa_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_other_manager.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_tinkoff_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  await registerGetIt();
  otherTests();
  tinkoffTests();
  alfaTests();
}

void otherTests() {
  test('Точка/Билайн на создание 0 проходов(0 проходов)', () {
    BankCard card = getMockBankCard(0, ActiveBank.tochka.index.toString(), BankCardType.tochka);
    LoungeCubit cubit = getMockCubit(card);
    var result = cubit.isPassageOver;
  
    /// если проходы закончились (==0) то вернуть maxPassengers, потому что будет оплата онлайн
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(true));
    expect(result2, equals(false));
  
    cubit.increasePassengers();
    cubit.increasePassengers();
    var result3 = cubit.state.passengersCount;
    expect(result3, equals(3));
  });

  test('Точка/Билайн на создание 8 проходов(7 проходов)', () {
    BankCard card = getMockBankCard(7, ActiveBank.tochka.index.toString(), BankCardType.tochka);
    LoungeCubit cubit = getMockCubit(card);
    for (int i = 0; i < 6; i++) {
      cubit.increasePassengers();
    }
    var result = cubit.isRichedMaxGuests;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(true));
    expect(result2, equals(true));
  });
  
  test('Точка/Билайн на создание 8 проходов(8 проходов)', () {
    BankCard card = getMockBankCard(8, ActiveBank.tochka.index.toString(), BankCardType.tochka);
    LoungeCubit cubit = getMockCubit(card);
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result = cubit.isRichedMaxGuests;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(true));
  });

  test('Точка/Билайн на создание 8 проходов(10 проходов)', () {
    BankCard card = getMockBankCard(10, ActiveBank.tochka.index.toString(), BankCardType.tochka);
    LoungeCubit cubit = getMockCubit(card);
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    //выбрано максимальное количество гостей
    var result = cubit.isRichedMaxGuests;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(true));
  });
}

void tinkoffTests() {

  ///isPassLimitEnable не используется при создании заказа в тинькофф

  test('Tinkoff Private на создание 0 проходов безлимит(0 проходов)', () {
    BankCard card = getMockBankCard(-1, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPrivate);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: true, count: 0));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    expect(result, equals(true));
    expect(result2, equals(false));
    expect(result3, equals(true));
  });
  
  test('Tinkoff Private на создание 5 проходов безлимит(5 проходов)', () {
    BankCard card = getMockBankCard(-1, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPrivate);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: true, count: 5));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 4; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(true));
    expect(result7, equals(true));
  });

  test('Tinkoff Private на создание 8 проходов безлимит(10 проходов)', () {
    BankCard card = getMockBankCard(-1, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPrivate);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: true, count: 10));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(false));
    expect(result7, equals(false));
  });
  
  test('Tinkoff Premium на создание 0 проходов Лимит(0 проходов)', () {
    BankCard card = getMockBankCard(0, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPremium);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: false, count: 0));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    expect(result, equals(true));
    expect(result2, equals(false));
    expect(result3, equals(false));
  });
  
  test('Tinkoff Premium на создание 5 проходов Лимит(5 проходов)', () {
    BankCard card = getMockBankCard(5, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPremium);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: false, count: 5));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 4; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(false));
    expect(result7, equals(true));
  });

  test('Tinkoff Premium на создание 8 проходов Лимит(7 проходов)', () {
    BankCard card = getMockBankCard(7, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPremium);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: false, count: 7));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 6; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    var result8 = cubit.isRichedMaxGuests;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(false));
    expect(result7, equals(true));
    expect(result8, equals(true));
  });

  test('Tinkoff Premium на создание 8 проходов Лимит(8 проходов)', () {
    BankCard card = getMockBankCard(8, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPremium);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: false, count: 8));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    var result8 = cubit.isRichedMaxGuests;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(false));
    expect(result7, equals(true));
    expect(result8, equals(false));
  });

  test('Tinkoff Premium на создание 8 проходов Лимит(10 проходов)', () {
    BankCard card = getMockBankCard(10, ActiveBank.tinkoff.index.toString(), BankCardType.tinkoffPremium);
    LoungeCubit cubit = getMockCubit(card, tinkoffPassage: TinkoffPassage.mock(isInfinity: false, count: 10));
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    var result3 = cubit.passageManager?.needShowAttention;
    var result35 = cubit.isPassLimitEnable;
    expect(result, equals(false));
    expect(result2, equals(false));
    expect(result3, equals(false));
    expect(result35, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result4 = cubit.isPassageOver;
    var result5 = cubit.needDisableAdditionPassengers;
    var result6 = cubit.passageManager?.needShowAttention;
    var result7 = cubit.isPassLimitEnable;
    expect(result4, equals(false));
    expect(result5, equals(true));
    expect(result6, equals(false));
    expect(result7, equals(false));
  });
}

void alfaTests() {
  test('Alfa на создание 0 проходов безлимит(0 проходов)', () async {
    BankCard card = getMockBankCard(-1, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: false, passengersAvailableCount: 0));
    await cubit.passageManager?.checkPassage(Lounge.mock());
  
    ///при первом запуске покажет уведомление
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(true));
    expect(result2, equals(false));
  });
  
  test('Alfa на создание 5 проходов безлимит(5 проходов)', () async {
    BankCard card = getMockBankCard(-1, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 5));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 4; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(true));
    expect(result6, equals(true));
  });
  
  test('Alfa на создание 8 проходов безлимит (10 проходов)', () async {
    BankCard card = getMockBankCard(-1, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 10));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(false));
    expect(result6, equals(false));
  });
  
  test('Alfa на создание 0 проходов Лимит(0 проходов)', () async {
    BankCard card = getMockBankCard(0, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: false, passengersAvailableCount: 0));
    await cubit.passageManager?.checkPassage(Lounge.mock());
  
    ///при первом запуске покажет уведомление если true
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(true));
    expect(result2, equals(false));
  });
  
  test('Alfa на создание 5 проходов Лимит(5 проходов)', () async {
    BankCard card = getMockBankCard(5, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 5));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 4; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(false));
    expect(result6, equals(false));
  });

  test('Alfa на создание 8 проходов Лимит (7 проходов)', () async {
    BankCard card = getMockBankCard(7, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
    getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 10));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 6; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    var result7 = cubit.isRichedMaxGuests;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(false));
    expect(result6, equals(false));
    expect(result7, equals(true));
  });

  test('Alfa на создание 8 проходов Лимит (8 проходов)', () async {
    BankCard card = getMockBankCard(8, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
    getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 10));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    var result7 = cubit.isRichedMaxGuests;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(false));
    expect(result6, equals(false));
    expect(result7, equals(false));
  });

  test('Alfa на создание 8 проходов Лимит (10 проходов)', () async {
    BankCard card = getMockBankCard(10, ActiveBank.alfa.index.toString(), BankCardType.alfaClub);
    LoungeCubit cubit =
        getMockCubit(card, passageCheck: PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 10));
    await cubit.passageManager?.checkPassage(Lounge.mock());
    var result = cubit.isPassageOver;
    var result2 = cubit.needDisableAdditionPassengers;
    expect(result, equals(false));
    expect(result2, equals(false));
    for (int i = 0; i < 7; i++) {
      cubit.increasePassengers();
    }
    var result3 = cubit.isPassageOver;
    var result4 = cubit.needDisableAdditionPassengers;
    var result5 = cubit.passageManager?.needShowAttention;
    var result6 = cubit.isPassLimitEnable;
    expect(result3, equals(false));
    expect(result4, equals(true));
    expect(result5, equals(false));
    expect(result6, equals(false));
  });
}

BankCard getMockBankCard(int passes, String sdkId, BankCardType type) {
  return BankCard(
      id: 0,
      createdAt: '',
      updatedAt: '',
      sdkId: sdkId,
      maskedNumber: '',
      isActive: true,
      fake: true,
      type: type,
      passesCount: passes,
      selfPasses: 0,
      guestPasses: 0,
      rebillId: 0);
}

LoungeCubit getMockCubit(BankCard card, {PassageCheck? passageCheck, TinkoffPassage? tinkoffPassage}) {
  late PassageManager manager;
  if (card.type == BankCardType.alfaClub) {
    manager = PassageAlfaManager(
        checkPassageUseCase: CheckPassageUseCaseImplMock(
      passageCheck: passageCheck ?? PassageCheck.mock(passagePayAvailable: true, passengersAvailableCount: 5),
    ));
  } else if (isTinkoffTypeCard(card.type)) {
    manager = PassageTinkoffManager(
      tinkoffPassUseCase: TinkoffPassUseCaseImplMock(
        tinkoffPassage: tinkoffPassage ?? TinkoffPassage.mock(isInfinity: false, count: 2),
      ),
    );
  } else {
    manager = PassageOtherManager();
  }
  manager.activeBankCard = card;

  return LoungeCubit(
      lounge: Lounge.mock(),
      activeCard: card,
      getUserUseCase: GetUserUseCaseImplMock(),
      getCardsUseCase: GetCardsUseCaseImplMock(),
      checkAAHealthUseCase: CheckAAHealthUseCaseImplMock(),
      attachCardCubit: null,
      findOutHideParamsUseCase: FindOutHideParamsUseCaseImplMock(),
      translitUseCase: TranslitUseCaseImplMock(),
      createOrderUseCase: CreateOrderUseCaseImplMock(),
      orderUseCase: GetUserOrdersUseCaseImplMock(),
      payWithPassUseCase: PayWithPassUseCaseImplMock(),
      payOrderCubit: null,
      passageManager: manager);
}
