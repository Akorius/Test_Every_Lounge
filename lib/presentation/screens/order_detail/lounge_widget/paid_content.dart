import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaidContent extends StatelessWidget {
  final Order order;

  const PaidContent({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (order.showPasses)
                Text(
                  "Оформлено: ${TextUtils.passesText(order.passengers.length)}",
                  style: context.textStyles.textOrderDetailsNormal(
                    color: context.colors.textOrderDetailsBlue,
                    ruble: true,
                  ),
                )
              else
                Text(
                  "Оплачено: ${MoneyFormatter.getFormattedCost(
                    order.amount,
                  )}₽",
                  style: context.textStyles.textOrderDetailsNormal(
                    color: context.colors.textOrderDetailsBlue,
                    ruble: true,
                  ),
                ),
              Text(
                DateFormat('dd.MM.yyyy').format(order.createdAt),
                style: context.textStyles.textOrderDetailsNormal(color: context.colors.textOrderDetailsBlue),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Действителен до",
                style: context.textStyles.textOrderDetailsNormal(color: context.colors.textOrderDetailsTitle),
              ),
              Text(
                DateFormat('dd.MM.yyyy').format(
                  order.validTill.isNotEmpty ? DateTime.parse(order.validTill) : DateTime.now(),
                ),
                style: context.textStyles.textOrderDetailsNormal(color: context.colors.textOrderDetailsTitle),
              ),
            ],
          )
        ],
      ),
    );
  }
}
