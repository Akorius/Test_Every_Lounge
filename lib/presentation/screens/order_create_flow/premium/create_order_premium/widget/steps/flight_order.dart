import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/about_ticket_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class FlightOrderData extends StatelessWidget {
  const FlightOrderData({
    super.key,
    this.padding,
    required this.originAirportCode,
    required this.originAirportName,
    required this.originCityName,
    required this.destinationAirportCode,
    required this.destinationAirportName,
    required this.destinationCityName,
    required this.flightNumber,
    required this.date,
    required this.time,
  });

  final EdgeInsets? padding;
  final String originAirportCode;
  final String originAirportName;
  final String originCityName;
  final String destinationAirportCode;
  final String destinationAirportName;
  final String destinationCityName;
  final String flightNumber;
  final DateTime date;
  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              originAirportCode,
              style: context.textStyles.h1(color: context.colors.textDarkPurple).copyWith(fontSize: 32),
            ),
            SvgPicture.asset(AppImages.plane, color: context.colors.buttonInfoText.withOpacity(0.5)),
            Text(
              destinationAirportCode,
              style: context.textStyles.h1(color: context.colors.textDarkPurple).copyWith(fontSize: 32),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CityAirportName(airportName: originAirportName, cityName: originCityName),
            const SizedBox(
              width: 16,
            ),
            CityAirportName(airportName: destinationAirportName, cityName: destinationCityName, isLeft: false),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AboutTicketWidget(title: 'Рейс', text: flightNumber),
            const SizedBox(height: 4),
            AboutTicketWidget(title: 'Дата', text: DateFormat('dd.MM.yy', 'ru_Ru').format(date)),
            const SizedBox(height: 4),
            AboutTicketWidget(title: 'Время', text: time.format(context)),
          ],
        ),
      ],
    );
  }
}

class CityAirportName extends StatelessWidget {
  const CityAirportName({
    super.key,
    required this.airportName,
    required this.cityName,
    this.isLeft = true,
  });

  final String airportName;
  final String cityName;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            airportName,
            maxLines: 1,
            textAlign: isLeft ? TextAlign.start : TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.textNormalRegularGrey(),
          ),
          Text(
            cityName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.textNormalRegularGrey(),
          ),
        ],
      ),
    );
  }
}
