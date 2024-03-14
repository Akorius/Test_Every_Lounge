import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_leg.dart';
import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/widget/flight_order.dart';
import 'package:flutter/material.dart';

import 'list_passengers.dart';

class OrderSegmentsList extends StatelessWidget {
  const OrderSegmentsList({
    Key? key,
    required this.leg,
    required this.passengers,
    required this.isPremiumStatusAlfa,
  }) : super(key: key);

  final AeroflotLeg? leg;
  final List<Passenger> passengers;
  final bool isPremiumStatusAlfa;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: leg?.segments.length ?? 0,
      itemBuilder: (BuildContext context, int i) {
        var segment = leg?.segments[i];
        var passInSegment = passengers.where((element) => element.segmentNumber == (segment?.segmentNumber ?? 0)).toList();
        if (passInSegment.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
          margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
          decoration: BoxDecoration(
            gradient: isPremiumStatusAlfa ? context.colors.alfaUpgradeStatusBackground : null,
            color: context.colors.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            children: [
              FlightOrderData(
                originAirportCode: segment?.origin.airportCode ?? "",
                originAirportName: segment?.origin.airportName ?? "",
                originCityName: segment?.origin.cityName ?? "",
                destinationAirportCode: segment?.destination.airportCode ?? "",
                destinationAirportName: segment?.destination.airportName ?? "",
                destinationCityName: segment?.destination.cityName ?? "",
                flightNumber: segment?.flightNumber ?? "",
                departureDate: segment?.departureDateName ?? "",
                departureTime: segment?.departureTime ?? "",
                padding: const EdgeInsets.only(left: 16, right: 16),
              ),
              const SizedBox(height: 8),
              ListPassengersInTicket(
                passengers: passInSegment,
              ),
            ],
          ),
        );
      },
    );
  }
}
