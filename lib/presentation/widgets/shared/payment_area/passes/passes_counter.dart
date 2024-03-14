import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PassesCounter extends StatelessWidget {
  final num price;
  final int passesCount;

  const PassesCounter({
    Key? key,
    required this.price,
    required this.passesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "${TextUtils.passesText(passesCount)} x ${NumberFormat.decimalPattern('ru').format(price)}",
              style: context.textStyles.textLargeRegular(
                color: context.colors.textOrderDetailsTitle,
                ruble: true,
              ),
            ),
            Text(
              " ₽",
              style: context.textStyles.textLargeRegular(
                color: context.colors.textOrderDetailsTitle,
                ruble: true,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              NumberFormat.decimalPattern('ru').format(price * passesCount),
              style: context.textStyles.h2(
                color: context.colors.textOrderDetailsTitle,
                ruble: true,
              ),
            ),
            Text(
              " ₽",
              style: context.textStyles.h2(
                color: context.colors.textOrderDetailsTitle,
                ruble: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
