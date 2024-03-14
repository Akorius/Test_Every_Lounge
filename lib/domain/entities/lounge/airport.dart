import 'package:everylounge/domain/entities/lounge/point.dart';

class Airport {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String code;
  final String name;
  final String city;
  final String country;
  final String countryCode;
  final Object? image;
  final bool? public;
  final Object? loc;
  final String timeZone;
  final int utcOffsetHour;
  final Point point;

  Airport({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
    required this.name,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.image,
    required this.public,
    required this.loc,
    required this.timeZone,
    required this.utcOffsetHour,
    required this.point,
  });

  factory Airport.fromJson(Map<dynamic, dynamic> json) => Airport(
        id: json['id'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        countryCode: json['country_code'] as String,
        image: json['image'],
        public: json['public'] as bool?,
        loc: json['loc'],
        timeZone: json['time_zone'] as String,
        utcOffsetHour: json['utc_offset_hour'] as int,
        point: Point.fromJson(json['point']),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'code': code,
      'name': name,
      'city': city,
      'country': country,
      'country_code': countryCode,
      'image': image,
      'public': public,
      'loc': loc,
      'time_zone': timeZone,
      'utc_offset_hour': utcOffsetHour,
      'point': point.toJson(),
    };
  }
}
