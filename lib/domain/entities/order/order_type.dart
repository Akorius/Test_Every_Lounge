enum OrderType {
  lounge,
  premium,
  upgrade,
  unknown,
}

extension OrderTypeExtension on OrderType {
  static OrderType fromInt(int number) {
    switch (number) {
      case 0:
        return OrderType.lounge;
      case 1:
        return OrderType.premium;
      case 2:
        return OrderType.upgrade;
      default:
        return OrderType.unknown;
    }
  }
}
