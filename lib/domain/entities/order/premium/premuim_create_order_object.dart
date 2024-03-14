import 'package:everylounge/domain/entities/order/premium/flight_create_order_object.dart';
import 'package:everylounge/domain/entities/order/premium/premium_passengers.dart';

import '../contacts.dart';

class PremiumCreateOrderObject {
  int serviceId;
  Contacts contacts;
  List<PremiumPassengers> passengers;
  List<FlightCreateOrderObject> flights;
  bool isTransit;

  PremiumCreateOrderObject({
    required this.serviceId,
    required this.contacts,
    required this.passengers,
    required this.flights,
    required this.isTransit,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['serviceId'] = serviceId;
    json['contacts'] = contacts.toJson();
    json['passengers'] = passengers.map((v) => v.toJson()).toList();
    json['flights'] = flights.map((v) => v.toJson()).toList();
    json['is_transit'] = isTransit;
    return json;
  }
}
