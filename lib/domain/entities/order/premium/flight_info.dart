import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';

class FlightInfo {
  final String airportCode;
  final String airportName;
  final String airportCity;
  final DateTime date;
  final String number;
  final AirportDestinationType type;

  const FlightInfo({
    required this.airportCode,
    required this.airportName,
    required this.airportCity,
    required this.date,
    required this.number,
    required this.type,
  });

  factory FlightInfo.fromJson(Map<dynamic, dynamic> json) => FlightInfo(
        airportCode: json['airport'],
        airportName: json['name'],
        airportCity: json['city'],
        date: DateTime.tryParse(json['date']) ?? DateTime.now(),
        number: json['number'],
        type: (json['direction'] as String).isNotEmpty == true
            ? AirportDestinationType.values.byName((json['direction'] as String).toLowerCase())
            : AirportDestinationType.departure,
      );

  Map<String, dynamic> toJson() {
    return {
      'airport': airportCode,
      'name': airportName,
      'city': airportCity,
      'date': date.toString(),
      'number': number,
      'direction': type.name,
    };
  }

  InnerDestinationType getInnerDestinationType() {
    switch (type) {
      case AirportDestinationType.arrival:
        return InnerDestinationType.arrival;
      case AirportDestinationType.departure:
      default:
        return InnerDestinationType.departure;
    }
  }
}
