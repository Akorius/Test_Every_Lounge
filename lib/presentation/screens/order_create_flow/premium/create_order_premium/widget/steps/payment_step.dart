import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/flight_order.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/list_passengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentStep extends StatelessWidget {
  const PaymentStep({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arrivalData = context.read<CreateOrderPremiumCubit>().flightArrivalData;
    var departureData = context.read<CreateOrderPremiumCubit>().flightDepartureData;
    return BlocBuilder<CreateOrderPremiumCubit, CreateOrderPremiumState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (arrivalData.airport != null)
            PaymentStepBody(
              airport: arrivalData.airport,
              service: state.service,
              flightNumber: arrivalData.flightNumberController.text,
              date: arrivalData.date ?? DateTime.now(),
              time: arrivalData.time ?? TimeOfDay.now(),
              passengers: state.createdOrder?.passengers ?? [],
            ),
          if (departureData.airport != null && arrivalData.airport != null)
            Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    height: 9,
                    width: 1,
                    decoration: BoxDecoration(
                      color: context.colors.backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                  ),
                  Text(
                    'Пересадка',
                    style: context.textStyles.textSmallBold(color: context.colors.textLight),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    height: 9,
                    width: 1,
                    decoration: BoxDecoration(
                      color: context.colors.backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (departureData.airport != null)
            PaymentStepBody(
              type: AirportDestinationType.departure,
              airport: departureData.airport,
              service: state.service,
              flightNumber: departureData.flightNumberController.text,
              date: departureData.date ?? DateTime.now(),
              time: departureData.time ?? TimeOfDay.now(),
              passengers: state.createdOrder?.passengers ?? [],
            ),
        ],
      ),
    );
  }
}

class PaymentStepBody extends StatelessWidget {
  const PaymentStepBody({
    super.key,
    required this.airport,
    required this.service,
    required this.flightNumber,
    required this.date,
    required this.time,
    required this.passengers,
    this.type,
  });

  final Airport? airport;
  final PremiumService service;
  final String flightNumber;
  final DateTime date;
  final TimeOfDay time;
  final List<Passenger> passengers;
  final AirportDestinationType? type;

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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(left: 8, right: 8),
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
            child: type == AirportDestinationType.departure
                ? FlightOrderData(
                    originAirportCode: service.airport.code,
                    originAirportName: service.airport.name,
                    originCityName: service.airport.city,
                    destinationAirportCode: airport!.code,
                    destinationAirportName: airport!.name,
                    destinationCityName: airport!.city,
                    flightNumber: flightNumber,
                    date: date,
                    time: time,
                  )
                : FlightOrderData(
                    originAirportCode: airport!.code,
                    originAirportName: airport!.name,
                    originCityName: airport!.city,
                    destinationAirportCode: service.airport.code,
                    destinationAirportName: service.airport.name,
                    destinationCityName: service.airport.city,
                    flightNumber: flightNumber,
                    date: date,
                    time: time,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListPassengersInTicket(
              passengers: passengers,
            ),
          ),
        ],
      ),
    );
  }
}
