import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class AirportItemWidget extends StatelessWidget {
  final Airport airport;
  final Color? backgroundColor;
  final EdgeInsets? margin;

  const AirportItemWidget(
    this.airport, {
    required this.backgroundColor,
    required this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: context.colors.avatarBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: Text(
                airport.code,
                style: context.textStyles.header700(color: context.colors.textLight),
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                airport.name.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        airport.name,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: context.textStyles.textLargeBold(color: context.colors.textDefault),
                        overflow: TextOverflow.ellipsis,
                      ),
                AutoSizeText(
                  airport.country.isNotEmpty ? "${airport.city}, ${airport.country}" : airport.city,
                  maxLines: 1,
                  minFontSize: 14,
                  style: airport.name.isEmpty
                      ? context.textStyles.textLargeBold(color: context.colors.textDefault)
                      : context.textStyles.textNormalRegular(color: context.colors.textAirportCity),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
