import 'package:collection/collection.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/domain/entities/order/rule.dart';

class Rate {
  final String? name;
  final bool? isChild;
  final AirportDestinationType? type;
  final String? flightDirection;
  final int? value;
  final List<Rule>? rules;

  Rate({
    this.name,
    this.isChild,
    this.type,
    this.flightDirection,
    this.value,
    this.rules,
  });

  bool get isGroupRate =>
      rules?.firstWhereOrNull((element) => element.name == "GroupRateRule" && element.minSize != null) != null;

  factory Rate.fromJson(Map<dynamic, dynamic> json) => Rate(
        name: json['name'] as String?,
        isChild: ((json['category'] as String?) == "Adult"),
        type: (json['type'] as String?)?.isNotEmpty == true
            ? AirportDestinationType.values.byName((json['type'] as String).toLowerCase())
            : AirportDestinationType.departure,
        value: json['value'] as int?,
        flightDirection: FlightDirection.getTranslatedName((json['flight_direction'] as String?) ?? ''),
        rules: ((json['rules'] ?? []) as List<dynamic>).map((e) => Rule.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isChild': isChild,
      'type': type?.name,
      'flightDirection': flightDirection,
      'value': value,
      'rules': rules?.map((rule) => rule.toJson()).toList(),
    };
  }

  factory Rate.mock() => Rate(
        name: 'Ivan',
        isChild: false,
        type: AirportDestinationType.departure,
        flightDirection: FlightDirection.domesticFlightDirection,
        value: 3666,
        rules: [Rule.mock()],
      );
}
