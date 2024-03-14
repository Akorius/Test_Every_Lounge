import 'package:everylounge/domain/entities/upgrade_flight/place.dart';
import 'package:everylounge/domain/entities/upgrade_flight/to_flight_class.dart';
import 'package:everylounge/domain/entities/upgrade_flight/upgrades.dart';

class Segment {
  Segment({
    required this.airlineCode,
    required this.cabin,
    required this.cabinName,
    required this.destination,
    required this.flightNumber,
    required this.flightTimeName,
    required this.origin,
    required this.segmentNumber,
    required this.statusCode,
    required this.upgrades,
    required this.departureDate,
    required this.departureTime,
  });

  final String airlineCode;
  final String cabin;
  final String cabinName;
  final Place destination;
  final String flightNumber;
  final String flightTimeName;
  final Place origin;
  final int segmentNumber;
  final String statusCode;
  final List<Upgrades?>? upgrades;
  final String departureDate;
  final String departureTime;

  Segment.mock({String? flightNumber})
      : this(
          airlineCode: 'AFL',
          cabin: '',
          cabinName: '',
          flightNumber: flightNumber ?? 'UT 812',
          flightTimeName: DateTime.now().toString(),
          destination: Place(airportCode: 'DLM', airportName: 'Даламан', cityCode: '', cityName: 'Мугла Даламан'),
          origin: Place(airportCode: 'DME', airportName: 'Домодедово', cityCode: '', cityName: 'Москва'),
          segmentNumber: 675,
          statusCode: '',
          upgrades: [
            Upgrades(
              refNumber: "12",
              toBusiness: ToFlightClass.mock(),
              toComfort: ToFlightClass.mock(),
            )
          ],
          departureDate: '12 мая',
          departureTime: '12:56',
        );

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        airlineCode: json['airline_code'],
        cabin: json['cabin'],
        cabinName: json['cabin_name'],
        destination: Place.fromJson(json['destination']),
        flightNumber: json['flight_number'],
        flightTimeName: json['flight_time_name'],
        origin: Place.fromJson(json['origin']),
        segmentNumber: json['segment_number'],
        statusCode: json['status_code'],
        upgrades: json['upgrades'] != null ? List.from(json['upgrades']).map((e) => Upgrades.fromJson(e)).toList() : null,
        departureDate: json['departure_date'],
        departureTime: json['departure_time'],
      );
}
