import 'package:everylounge/domain/entities/bank/bank.dart';

enum BankCardType {
  other, //0
  gazpromDefault, //1
  gazpromPremium, //2
  gazpromPrivate, //3
  moscowCredit, //4
  raiffeisen, //5
  alfaClub, //6
  tinkoffDefault, //7 фейк
  tinkoffPremium, //8 фейк
  tinkoffPrivate, //9 фейк
  tinkoffPro, //10 фейк
  otkrytie, //11
  tochka, //12 фейк
  beelineKZ, //13 фейк
  alfaPrem, //14
}

int getIndexByActiveCard(BankCardType cardType) {
  switch (cardType) {
    case BankCardType.other:
    case BankCardType.otkrytie:
    case BankCardType.moscowCredit:
    case BankCardType.gazpromDefault:
    case BankCardType.gazpromPremium:
    case BankCardType.gazpromPrivate:
    case BankCardType.raiffeisen:
      return ActiveBank.none.index;
    case BankCardType.alfaClub:
      return ActiveBank.alfa.index;
    case BankCardType.alfaPrem:
      return ActiveBank.alfa.index;
    case BankCardType.tochka:
      return ActiveBank.tochka.index;
    case BankCardType.beelineKZ:
      return ActiveBank.beelineKZ.index;
    case BankCardType.tinkoffDefault:
    case BankCardType.tinkoffPremium:
    case BankCardType.tinkoffPrivate:
    case BankCardType.tinkoffPro:
      return ActiveBank.tinkoff.index;
  }
}

BankCardType bankCardTypeFromInt(int number) {
  switch (number) {
    case 0:
      return BankCardType.other;
    case 1:
      return BankCardType.gazpromDefault;
    case 2:
      return BankCardType.gazpromPremium;
    case 3:
      return BankCardType.gazpromPrivate;
    case 4:
      return BankCardType.moscowCredit;
    case 5:
      return BankCardType.raiffeisen;
    case 6:
      return BankCardType.alfaClub;
    case 7:
      return BankCardType.tinkoffDefault;
    case 8:
      return BankCardType.tinkoffPremium;
    case 9:
      return BankCardType.tinkoffPrivate;
    case 10:
      return BankCardType.tinkoffPro;
    case 11:
      return BankCardType.otkrytie;
    case 12:
      return BankCardType.tochka;
    case 13:
      return BankCardType.beelineKZ;
    case 14:
      return BankCardType.alfaPrem;
    default:
      return BankCardType.other;
  }
}

bool isGazPromPremiumTypeCard(BankCardType? type) {
  return type == BankCardType.gazpromPremium || type == BankCardType.gazpromPrivate;
}

bool isTinkoffTypeCard(BankCardType? type) {
  return type == BankCardType.tinkoffPremium ||
      type == BankCardType.tinkoffPrivate ||
      type == BankCardType.tinkoffPro ||
      type == BankCardType.tinkoffDefault;
}

bool isAlfaTypeCard(BankCardType? type) {
  return type == BankCardType.alfaPrem || type == BankCardType.alfaClub;
}

String getBankName(BankCardType? type) {
  switch (type) {
    case BankCardType.gazpromDefault:
    case BankCardType.gazpromPremium:
    case BankCardType.gazpromPrivate:
      return "Газпромбанка";
    case BankCardType.tinkoffDefault:
    case BankCardType.tinkoffPremium:
    case BankCardType.tinkoffPrivate:
    case BankCardType.tinkoffPro:
      return "Тинкофф";
    case BankCardType.otkrytie:
      return "Открытие";
    case BankCardType.moscowCredit:
      return "МКБ";
    case BankCardType.raiffeisen:
    case BankCardType.alfaClub:
    case BankCardType.tochka:
    case BankCardType.other:
    default:
      return '';
  }
}
