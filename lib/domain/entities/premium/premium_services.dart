import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/domain/entities/lounge/point.dart';
import 'package:everylounge/domain/entities/order/document.dart';
import 'package:everylounge/domain/entities/order/rate.dart';
import 'package:everylounge/domain/entities/order/schedule.dart';

/// на бэке бизнес-зал и премиум услуга - это разные сущности
class PremiumService {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String description;
  final String organization;
  final Airport airport;
  final String terminal;
  final ServiceKind kind; // MeetAndAssist|VipLounge|FastTrack
  final AirportDestinationType type; // Departure|Arrival
  final String? flightDirection; // Any|Domestic
  final String? location;
  final List<Schedule>? schedule;
  final List<String>? features;
  final List<String>? featuresRus;
  final List<String>? amenities;
  final List<String>? amenitiesRus;
  final String code;
  final List<String>? gallery;
  final List<Document>? documents;
  final String? maxStayDuration;
  final int? minAdultAge;
  final String internalId;
  final num commonCost;
  final int orderPosition;
  final bool isPublic;
  final int? logoId;
  final bool isTransit;
  final List<Rate> rates;

  PremiumService({
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
    required this.documents,
    required this.maxStayDuration,
    required this.minAdultAge,
    required this.internalId,
    required this.commonCost,
    required this.orderPosition,
    required this.isPublic,
    required this.logoId,
    required this.isTransit,
    required this.rates,
  });

  num cost({InnerDestinationType? destinationType}) {
    int? value;
    try {
      var filteredRates = destinationType == InnerDestinationType.transit
          ? rates
          : rates.where((element) => element.type?.name == destinationType?.name);
      filteredRates = filteredRates.where((element) => !element.isGroupRate);
      if (flightDirection != FlightDirection.anyFlightDirection) {
        filteredRates = filteredRates.where((element) => element.flightDirection == flightDirection);
      }
      value = filteredRates
          .where((rate) => rate.value != null && rate.value! > 0)
          .reduce((min, rate) => rate.value! < min.value! ? rate : min)
          .value;
    } catch (e) {
      //ignore
    }
    return value ?? commonCost;
  }

  String get airportTitle => airport.city.isEmpty
      ? airport.name
      : airport.name.isEmpty
          ? airport.city
          : "${airport.city}, ${airport.name}";

  PremiumService.mock({bool? isMeetAndAssist = false})
      : this(
          id: 404,
          createdAt: '2023-05-12T13:58:46.644789Z',
          updatedAt: '2023-05-12T13:58:46.644789Z',
          name: 'Индивидуальное сопровождение',
          description:
              '<p><b>Индивидуальное сопровождение на прилете включает:</b></p><ul><li><p>Трансфер от борта самолета до&nbsp;здания аэровокзала на&nbsp;комфортабельном автомобиле Мерседес Спринтер</p></li></ul>',
          organization: '8852311a-4f0e-424e-b5d6-a990b4e14467',
          terminal: 'Международный терминал',
          kind: ServiceKind.meetandassist,
          type: AirportDestinationType.arrival,
          flightDirection: 'Международный',
          location: '',
          schedule: [],
          features: [],
          featuresRus: [],
          amenities: [],
          amenitiesRus: [],
          code: '',
          gallery: [],
          documents: [],
          maxStayDuration: '',
          minAdultAge: 7,
          internalId: '',
          commonCost: 3000,
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
          isTransit: false,
          rates: [Rate.mock()],
        );

  String serviceName() {
    switch (kind) {
      case ServiceKind.viplounge:
        return 'VIP зал';
      case ServiceKind.meetandassist:
        return 'Индивидуальное сопровождение';
      case ServiceKind.fasttrack:
      default:
        return 'Услуга "Fast track"';
    }
  }

  factory PremiumService.fromJson(Map<dynamic, dynamic> json) => PremiumService(
        id: json['id'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        organization: json['organization'] as String,
        airport: Airport.fromJson(json['airport']),
        terminal: json['terminal'] as String,
        kind: (json['kind'] as String).isNotEmpty == true
            ? ServiceKind.values.byName((json['kind'] as String).toLowerCase())
            : ServiceKind.meetandassist,
        type: (json['type'] as String).isNotEmpty == true
            ? AirportDestinationType.values.byName((json['type'] as String).toLowerCase())
            : AirportDestinationType.departure,
        flightDirection: FlightDirection.getTranslatedName((json['flight_direction'] as String?) ?? ''),
        location: json['location'] as String?,
        schedule: (json['schedule'] as List<dynamic>?)?.map((e) => Schedule.fromJson(e)).toList(),
        features: (json['features'] as List<dynamic>?)?.map((e) => e as String).toList(),
        featuresRus: (json['features_rus'] as List<dynamic>?)?.map((e) => e as String).toList(),
        amenities: json['amenities']?.cast<String>(),
        amenitiesRus: json['amenities_rus']?.cast<String>(),
        code: json['code'] as String,
        gallery: ((json['gallery'] ?? []) as List<dynamic>).map((e) => e as String).toList(),
        documents: (json['documents'] as List<dynamic>?)?.map((e) => Document.fromJson(e)).toList(),
        maxStayDuration: json['max_stay_duration'] as String?,
        minAdultAge: json['min_adult_age'] as int?,
        internalId: json['internal_id'] as String,
        commonCost: json['cost'] ?? 0,
        orderPosition: json['order_position'] as int,
        isPublic: json['is_public'] as bool,
        logoId: json['logo_id'] as int?,
        isTransit: (json['is_transit'] as bool?) ?? false,
        rates: ((json['rates'] ?? []) as List<dynamic>).map((e) => Rate.fromJson(e)).toList(),
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
      'kind': kind.name,
      'type': type.name,
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
      'cost': commonCost,
      'order_position': orderPosition,
      'is_public': isPublic,
      'logo_id': logoId,
      'is_transit': isTransit,
      'documents': documents?.map((e) => e.toJson()).toList(),
    };
  }

  PremiumService copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? name,
    String? description,
    String? organization,
    Airport? airport,
    String? terminal,
    ServiceKind? kind,
    AirportDestinationType? type,
    String? flightDirection,
    String? location,
    List<Schedule>? schedule,
    List<String>? features,
    List<String>? featuresRus,
    List<String>? amenities,
    List<String>? amenitiesRus,
    String? code,
    List<String>? gallery,
    List<Document>? documents,
    String? maxStayDuration,
    int? minAdultAge,
    String? internalId,
    num? cost,
    int? orderPosition,
    bool? isPublic,
    int? logoId,
    bool? isTransit,
    List<Rate>? rates,
  }) {
    return PremiumService(
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
      documents: documents ?? this.documents,
      maxStayDuration: maxStayDuration ?? this.maxStayDuration,
      minAdultAge: minAdultAge ?? this.minAdultAge,
      internalId: internalId ?? this.internalId,
      commonCost: cost ?? this.commonCost,
      orderPosition: orderPosition ?? this.orderPosition,
      isPublic: isPublic ?? this.isPublic,
      logoId: logoId ?? this.logoId,
      isTransit: isTransit ?? this.isTransit,
      rates: rates ?? this.rates,
    );
  }
}

enum ServiceKind { meetandassist, viplounge, fasttrack }
