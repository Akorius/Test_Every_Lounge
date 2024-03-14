import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/state.dart';
import 'package:flutter/material.dart';

import 'flight_order.dart';
import 'list_passengers.dart';

class SegmentItem extends StatelessWidget {
  const SegmentItem({
    Key? key,
    required this.segment,
    required this.state,
  }) : super(key: key);

  final Segment segment;
  final CreateUpgradeOrderState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlightOrderData(
              originAirportCode: segment.origin.airportCode,
              originAirportName: segment.origin.airportName,
              originCityName: segment.origin.cityName,
              destinationAirportCode: segment.destination.airportCode,
              destinationAirportName: segment.destination.airportName,
              destinationCityName: segment.destination.cityName,
              flightNumber: segment.flightNumber,
              departureDate: segment.departureDate,
              departureTime: segment.departureTime,
            ),
          ),
          ListPassengersInOrder(
            segment: segment,
            state: state,
          ),
        ],
      ),
    );
  }
}
