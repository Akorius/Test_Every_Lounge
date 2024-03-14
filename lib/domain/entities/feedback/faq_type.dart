enum FaqType { lounge, upgrade, premiumService }

extension FaqTypeExt on FaqType {
  static FaqType fromInt(int num) {
    switch (num) {
      case 0:
        return FaqType.lounge;
      case 1:
        return FaqType.upgrade;
      case 2:
      default:
        return FaqType.premiumService;
    }
  }
}
