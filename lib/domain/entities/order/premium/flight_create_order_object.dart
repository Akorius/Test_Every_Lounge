import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightCreateOrderObject {
  String airportCode;
  DateTime date;
  TimeOfDay time;
  String flightNumber;
  String direction;

  FlightCreateOrderObject({
    required this.airportCode,
    required this.date,
    required this.time,
    required this.flightNumber,
    required this.direction,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['airport'] = airportCode;
    json['date'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
    json['number'] = flightNumber;
    json['direction'] = direction;
    return json;
  }
}
