import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Total extends StatelessWidget {
  final num price;
  final String? title;

  const Total({
    Key? key,
    required this.price,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? 'Итого',
          style: context.textStyles.textLargeRegular(
            color: context.colors.textOrderDetailsTitle,
            ruble: true,
          ),
        ),
        Row(
          children: [
            Text(
              NumberFormat.decimalPattern('ru').format(price),
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
