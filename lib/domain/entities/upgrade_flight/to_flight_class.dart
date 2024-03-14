class ToFlightClass {
  ToFlightClass({
    required this.amount,
    required this.available,
    required this.currency,
    required this.miles,
    required this.rficCode,
    required this.rfiscCode,
    required this.selected,
  });

  final String amount;
  final bool available;
  final String currency;
  final String miles;
  final String rficCode;
  final String rfiscCode;
  final bool selected;

  factory ToFlightClass.mock() => ToFlightClass(
        amount: "13600.00",
        available: true,
        currency: "RUB",
        miles: "",
        rficCode: "A",
        rfiscCode: "060",
        selected: false,
      );

  factory ToFlightClass.fromJson(Map<String, dynamic> json) => ToFlightClass(
        amount: json['amount'],
        available: json['available'],
        currency: json['currency'],
        miles: json['miles'],
        rficCode: json['rfic_code'],
        rfiscCode: json['rfisc_code'],
        selected: json['selected'],
      );
}
