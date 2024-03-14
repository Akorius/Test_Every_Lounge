import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/domain/entities/lounge/point.dart';
import 'package:everylounge/domain/entities/order/schedule.dart';

class Lounge {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String description;
  final String organization;
  final Airport airport;
  final String terminal;
  final String kind;
  final String type;
  final String? flightDirection;
  final String? location;
  final List<Schedule>? schedule;
  final List<String>? features;
  final List<String>? featuresRus;
  final List<String>? amenities;
  final List<String>? amenitiesRus;
  final String code;
  final List<String>? gallery;
  final String? maxStayDuration;
  final int? minAdultAge;
  final String internalId;
  final num cost;
  final int orderPosition;
  final bool isPublic;
  final int? logoId;

  Lounge({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.organization,
    required this.airport,
    required this.terminal,
    required this.kind,
    required this.type,
    required this.flightDirection,
    required this.location,
    required this.schedule,
    required this.features,
    required this.featuresRus,
    required this.amenities,
    required this.amenitiesRus,
    required this.code,
    required this.gallery,
    required this.maxStayDuration,
    required this.minAdultAge,
    required this.internalId,
    required this.cost,
    required this.orderPosition,
    required this.isPublic,
    required this.logoId,
  });

  String get airportTitle => airport.city.isEmpty
      ? airport.name
      : airport.name.isEmpty
          ? airport.city
          : "${airport.city}, ${airport.name}";

  Lounge.mock()
      : this(
          id: 404,
          createdAt: '',
          updatedAt: '',
          name: 'Бизнес-зал Платов',
          // description: 'Длинное название, описание бизнес залов, первый, второй, третий зал. Длинное название, описание бизнес залов, первый, второй, третий зал',
          description: '',
          organization: 'a8a44b20-4c79-4fd1-a46a-486b7d783d58',
          terminal: 'Международный терминал',
          kind: '',
          type: "",
          flightDirection: FlightDirection.getTranslatedName('Any'),
          location: '',
          schedule: [],
          features: [],
          featuresRus: [],
          amenities: [],
          amenitiesRus: [],
          code: '',
          gallery: [],
          maxStayDuration: '',
          minAdultAge: 7,
          internalId: '',
          cost: 3000,
          orderPosition: 2,
          isPublic: true,
          airport: Airport(
            id: 1,
            createdAt: '',
            updatedAt: '',
            code: '',
            name: 'Платов',
            city: 'Ростов-на-Дону',
            country: '',
            countryCode: 'RU',
            image: null,
            public: true,
            loc: null,
            timeZone: '',
            utcOffsetHour: 3,
            point: Point(lng: 2, lat: 2),
          ),
          logoId: 0,
        );

  factory Lounge.fromJson(Map<dynamic, dynamic> json) => Lounge(
        id: json['id'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        organization: json['organization'] as String,
        airport: Airport.fromJson(json['airport']),
        terminal: json['terminal'] as String,
        kind: json['kind'] as String,
        type: json['type'] as String,
        flightDirection: FlightDirection.getTranslatedName((json['flight_direction'] as String?) ?? ''),
        location: json['location'] as String?,
        schedule: (json['schedule'] as List<dynamic>?)?.map((e) => Schedule.fromJson(e)).toList(),
        features: (json['features'] as List<dynamic>?)?.map((e) => e as String).toList(),
        featuresRus: (json['features_rus'] as List<dynamic>?)?.map((e) => e as String).toList(),
        amenities: json['amenities']?.cast<String>(),
        amenitiesRus: json['amenities_rus']?.cast<String>(),
        code: json['code'] as String,
        gallery: ((json['gallery'] ?? []) as List<dynamic>).map((e) => e as String).toList(),
        maxStayDuration: json['max_stay_duration'] as String?,
        minAdultAge: json['min_adult_age'] as int?,
        internalId: json['internal_id'] as String,
        cost: json['cost'],
        orderPosition: json['order_position'] as int,
        isPublic: json['is_public'] as bool,
        logoId: json['logo_id'] as int?,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'description': description,
      'organization': organization,
      'airport': airport.toJson(),
      'terminal': terminal,
      'kind': kind,
      'type': type,
      'flight_direction': flightDirection,
      'location': location,
      'schedule': schedule?.map((e) => e.toJson()).toList(),
      'features': features,
      'features_rus': featuresRus,
      'amenities': amenities,
      'amenities_rus': amenitiesRus,
      'code': code,
      'gallery': gallery,
      'max_stay_duration': maxStayDuration,
      'min_adult_age': minAdultAge,
      'internal_id': internalId,
      'cost': cost,
      'order_position': orderPosition,
      'is_public': isPublic,
      'logo_id': logoId,
    };
  }

  Lounge copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? name,
    String? description,
    String? organization,
    Airport? airport,
    String? terminal,
    String? kind,
    String? type,
    String? flightDirection,
    String? location,
    List<Schedule>? schedule,
    List<String>? features,
    List<String>? featuresRus,
    List<String>? amenities,
    List<String>? amenitiesRus,
    String? code,
    List<String>? gallery,
    String? maxStayDuration,
    int? minAdultAge,
    String? internalId,
    num? cost,
    int? orderPosition,
    bool? isPublic,
    int? logoId,
  }) {
    return Lounge(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      organization: organization ?? this.organization,
      airport: airport ?? this.airport,
      terminal: terminal ?? this.terminal,
      kind: kind ?? this.kind,
      type: type ?? this.type,
      flightDirection: flightDirection ?? this.flightDirection,
      location: location ?? this.location,
      schedule: schedule ?? this.schedule,
      features: features ?? this.features,
      featuresRus: featuresRus ?? this.featuresRus,
      amenities: amenities ?? this.amenities,
      amenitiesRus: amenitiesRus ?? this.amenitiesRus,
      code: code ?? this.code,
      gallery: gallery ?? this.gallery,
      maxStayDuration: maxStayDuration ?? this.maxStayDuration,
      minAdultAge: minAdultAge ?? this.minAdultAge,
      internalId: internalId ?? this.internalId,
      cost: cost ?? this.cost,
      orderPosition: orderPosition ?? this.orderPosition,
      isPublic: isPublic ?? this.isPublic,
      logoId: logoId ?? this.logoId,
    );
  }
}

enum LoungeType { lounge, premium, departure }
