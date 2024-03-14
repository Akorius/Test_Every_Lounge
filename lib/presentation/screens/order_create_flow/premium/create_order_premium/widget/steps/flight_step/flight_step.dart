import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/flight_step/flight_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlightStepWidget extends StatelessWidget {
  final InnerDestinationType type;
  final String? direction;
  final String? countryCode;
  final Function onTapForScroll;
  final bool isTransit;

  const FlightStepWidget(
    this.type,
    this.direction,
    this.countryCode,
    this.onTapForScroll,
    this.isTransit, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case InnerDestinationType.arrival:
        return FlightStepBody(
          flightDirection: direction,
          countryCode: countryCode,
          airportCode: context.read<CreateOrderPremiumCubit>().state.service.airport.code,
          data: context.read<CreateOrderPremiumCubit>().flightArrivalData,
          type: AirportDestinationType.arrival,
          onTapForScroll: onTapForScroll,
        );
      case InnerDestinationType.transit:
        return Column(
          children: [
            FlightStepBody(
                flightDirection: direction,
                countryCode: countryCode,
                airportCode: context.read<CreateOrderPremiumCubit>().state.service.airport.code,
                data: context.read<CreateOrderPremiumCubit>().flightArrivalData,
                type: AirportDestinationType.arrival,
                isFirst: true),
            FlightStepBody(
              flightDirection: direction,
              countryCode: countryCode,
              airportCode: context.read<CreateOrderPremiumCubit>().state.service.airport.code,
              data: context.read<CreateOrderPremiumCubit>().flightDepartureData,
              type: AirportDestinationType.departure,
              onTapForScroll: onTapForScroll,
              isFirst: false,
            )
          ],
        );
      case InnerDestinationType.departure:
      default:
        return FlightStepBody(
          flightDirection: direction,
          countryCode: countryCode,
          airportCode: context.read<CreateOrderPremiumCubit>().state.service.airport.code,
          data: context.read<CreateOrderPremiumCubit>().flightDepartureData,
          type: AirportDestinationType.departure,
          onTapForScroll: onTapForScroll,
        );
    }
  }
}
