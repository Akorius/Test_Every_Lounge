import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/terminal.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/fly_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPremium extends StatelessWidget {
  const AboutPremium(
    this.airportTitle,
    this.flightDirection,
    this.serviceName,
    this.destinationType,
    this.terminal, {
    super.key,
  });

  final String airportTitle;
  final String? flightDirection;
  final String serviceName;
  final InnerDestinationType destinationType;
  final String terminal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 10),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            airportTitle,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.textLargeRegular(
              color: context.colors.appBarText.withOpacity(0.6),
            ),
          ),
        ),
        Text(
          "(${flightDirection ?? ''})",
          style: context.textStyles.textLargeRegular(
            color: context.colors.appBarText.withOpacity(0.6),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Terminal(terminal),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12, left: 16, right: 16),
          child: Text(
            serviceName,
            textAlign: TextAlign.center,
            style: context.textStyles.h2(color: context.colors.appBarText),
          ),
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: FlyDirection(
            type: destinationType,
          ),
        ),
      ],
    );
  }
}
