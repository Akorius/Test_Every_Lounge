class FlightDirection {
  static String getTranslatedName(String name) {
    final map = {
      "International": internFlightDirection,
      "Domestic": domesticFlightDirection,
      "Any": anyFlightDirection,
    };
    return map[name] ?? name;
  }

  static String anyFlightDirection = "Международные и внутренние рейсы";
  static String domesticFlightDirection = "Внутренние рейсы";
  static String internFlightDirection = "Международные рейсы";

  static String anyTextSwitcher = "Все";
  static String domesticTextSwitcher = "Внутренние";
  static String internTextSwitcher = "Международные";
}
