import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
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
    required this.departureDate,
    required this.departureTime,
  });

  final EdgeInsets? padding;
  final String originAirportCode;
  final String originAirportName;
  final String originCityName;
  final String destinationAirportCode;
  final String destinationAirportName;
  final String destinationCityName;
  final String flightNumber;
  final String departureDate;
  final String departureTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF99ABC6).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Рейс $flightNumber${departureDate.isEmpty ? "" : " · ${getDate(departureDate)}"}",
            style: context.textStyles.textNormalRegular(color: context.colors.textDarkPurple),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      originAirportCode,
                      style: context.textStyles.h1(color: context.colors.textDarkPurple).copyWith(fontSize: 32),
                    ),
                    Text(
                      originAirportName,
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                    Text(
                      originCityName,
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                  ],
                ),
              ),
              Center(child: SvgPicture.asset(AppImages.plane, color: context.colors.buttonInfoText.withOpacity(0.5))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      destinationAirportCode,
                      style: context.textStyles.h1(color: context.colors.textDarkPurple).copyWith(fontSize: 32),
                    ),
                    Text(
                      destinationAirportName,
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                    Text(
                      destinationCityName,
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getDate(String date) {
    try {
      var dateTime = DateFormat('d MMMM y', 'ru_Ru').parse(date);
      return DateFormat('d MMMM', 'ru_Ru').format(dateTime);
    } catch (e) {
      return date;
    }
  }
}
