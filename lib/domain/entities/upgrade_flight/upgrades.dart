import 'package:everylounge/domain/entities/upgrade_flight/to_flight_class.dart';

class Upgrades {
  Upgrades({
    required this.refNumber,
    required this.toBusiness,
    required this.toComfort,
  });

  final String refNumber;
  final ToFlightClass toBusiness;
  final ToFlightClass toComfort;

  factory Upgrades.fromJson(Map<String, dynamic> json) => Upgrades(
        refNumber: json['ref_number'],
        toBusiness: ToFlightClass.fromJson(json['to_business']),
        toComfort: ToFlightClass.fromJson(json['to_comfort']),
      );
}
