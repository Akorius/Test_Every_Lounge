import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/premium/flight_info.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/flight_order.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/list_passengers.dart';
import 'package:flutter/material.dart';

class PremiumBodyContent extends StatelessWidget {
  const PremiumBodyContent(
    this.order, {
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          if (order.flightInfo != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.lightDashBorder.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: getOrderData(order.flightInfo!.first),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: ListPassengersInTicket(passengers: order.passengers),
          )
        ],
      ),
    );
  }

  FlightOrderData getOrderData(FlightInfo info) {
    if (info.type == AirportDestinationType.arrival) {
      return FlightOrderData(
        originAirportCode: info.airportCode,
        originAirportName: info.airportName,
        originCityName: info.airportCity,
        destinationAirportCode: order.premiumService?.airport.code ?? '',
        destinationAirportName: order.premiumService?.airport.name ?? '',
        destinationCityName: order.premiumService?.airport.city ?? '',
        flightNumber: info.number,
        date: info.date,
        time: TimeOfDay(hour: info.date.hour, minute: info.date.minute),
      );
    } else {
      return FlightOrderData(
        originAirportCode: order.premiumService?.airport.code ?? '',
        originAirportName: order.premiumService?.airport.name ?? '',
        originCityName: order.premiumService?.airport.city ?? '',
        destinationAirportCode: info.airportCode,
        destinationAirportName: info.airportName,
        destinationCityName: info.airportCity,
        flightNumber: info.number,
        date: info.date,
        time: TimeOfDay(hour: info.date.hour, minute: info.date.minute),
      );
    }
  }
}
