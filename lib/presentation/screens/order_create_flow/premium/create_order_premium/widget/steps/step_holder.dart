import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/flight_step/flight_step.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/passengers_step.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/payment_step.dart';
import 'package:flutter/material.dart';

class StepHolder extends StatelessWidget {
  final PremiumServiceCreateStep step;
  final InnerDestinationType type;
  final bool isTransit;
  final String? direction;
  final String? countryCode;
  final Function onTapForScroll;

  const StepHolder({
    super.key,
    required this.step,
    required this.type,
    required this.isTransit,
    required this.direction,
    required this.countryCode,
    required this.onTapForScroll,
  });

  @override
  Widget build(BuildContext context) {
    var stepsWidgetMap = {
      PremiumServiceCreateStep.flight: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: FlightStepWidget(type, direction, countryCode, onTapForScroll, isTransit),
      ),
      PremiumServiceCreateStep.passengers: const Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: PassengersStep(),
      ),
      PremiumServiceCreateStep.payment: const PaymentStep(),
    };

    return Container(
      child: stepsWidgetMap[step],
    );
  }
}
