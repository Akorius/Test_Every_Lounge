import 'package:everylounge/domain/entities/upgrade_flight/place.dart';

class AeroflotSegment {
  AeroflotSegment({
    required this.airlineCode,
    required this.departure,
    required this.departureDateName,
    required this.departureOffset,
    required this.departureTime,
    required this.flightNumber,
    required this.flightTimeName,
    required this.destination,
    required this.origin,
    required this.segmentNumber,
  });

  final String airlineCode;
  final String departure;
  final String departureDateName;
  final int departureOffset;
  final String departureTime;
  final String flightNumber;
  final String flightTimeName;
  final Place destination;
  final Place origin;
  final int segmentNumber;

  factory AeroflotSegment.fromJson(Map<dynamic, dynamic> json) => AeroflotSegment(
        airlineCode: json['airline_code'],
        departure: json['departure'],
        departureDateName: json['departure_date_name'],
        departureOffset: json['departure_offset'],
        departureTime: json['departure_time'],
        flightNumber: json['flight_number'],
        flightTimeName: json['flight_time_name'],
        destination: Place.fromJson(json['destination']),
        origin: Place.fromJson(json['origin']),
        segmentNumber: json['segment_number'],
      );

  factory AeroflotSegment.mock({int? segmentNumber}) => AeroflotSegment(
        airlineCode: 'AFL',
        departure: "",
        departureOffset: 1,
        departureDateName: '12 мая',
        departureTime: '12:56',
        flightNumber: 'UT 812',
        flightTimeName: '12:35',
        destination: Place(airportCode: 'DLM', airportName: 'Даламан', cityCode: '', cityName: 'Мугла Даламан'),
        origin: Place(airportCode: 'DME', airportName: 'Домодедово', cityCode: '', cityName: 'Москва'),
        segmentNumber: segmentNumber ?? 675,
      );

  Map<String, dynamic> toJson() {
    return {
      'airline_code': airlineCode,
      'departure': departure,
      'departure_date_name': departureDateName,
      'departure_offset': departureOffset,
      'departure_time': departureTime,
      'flight_number': flightNumber,
      'flight_time_name': flightTimeName,
      'destination': destination.toJson(),
      'origin': origin.toJson(),
      'segment_number': segmentNumber,
    };
  }
}
