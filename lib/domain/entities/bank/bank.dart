enum ActiveBank {
  none, //0
  tinkoff, //1
  gazprom, //2
  sber, //3
  alfa, //4
  moscowCredit, //5
  raiffeisen, //6
  tochka, //7
  otkrytie, //8
  beelineKZ, //9
}

enum ActiveBankStatus {
  standard,
  premium,
  private,
  pro,
  alfaClub,
}

bool bankForPaymentByPasses(ActiveBank? bank) {
  return bank == ActiveBank.alfa || bank == ActiveBank.tochka || bank == ActiveBank.beelineKZ || bank == ActiveBank.tinkoff;
}

bool bankForPaymentByPassesWithoutTinkoff(ActiveBank? bank) {
  return bank == ActiveBank.alfa || bank == ActiveBank.tochka || bank == ActiveBank.beelineKZ;
}

extension ActiveBankExtension on ActiveBank {
  static ActiveBank fromInt(int? number) {
    switch (number ?? 0) {
      case 0:
        return ActiveBank.none;
      case 1:
        return ActiveBank.tinkoff;
      case 2:
        return ActiveBank.gazprom;
      case 3:
        return ActiveBank.sber;
      case 4:
        return ActiveBank.alfa;
      case 5:
        return ActiveBank.moscowCredit;
      case 6:
        return ActiveBank.raiffeisen;
      case 7:
        return ActiveBank.tochka;
      case 8:
        return ActiveBank.otkrytie;
      case 9:
        return ActiveBank.beelineKZ;
      default:
        return ActiveBank.none;
    }
  }
}

extension ActiveBankStatusExtension on ActiveBankStatus {
  static ActiveBankStatus? fromInt(int? number) {
    switch (number) {
      case 0:
        return ActiveBankStatus.standard;
      case 1:
        return ActiveBankStatus.premium;
      case 2:
        return ActiveBankStatus.private;
      case 3:
        return ActiveBankStatus.pro;
      case 4:
        return ActiveBankStatus.alfaClub;
      default:
        return null;
    }
  }
}
