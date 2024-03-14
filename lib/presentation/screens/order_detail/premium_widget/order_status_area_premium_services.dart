import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_detail/premium_widget/widget/paid_order_widget.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomOrderStatusAreaPremiumServices extends StatelessWidget {
  final OrderDetailsState state;

  const BottomOrderStatusAreaPremiumServices({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state.order.status) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
      case OrderStatus.cancelled:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.order.status.getDesignation(),
              style: context.textStyles.textOrderDetailsNormal(
                color: context.colors.textDefault,
                ruble: true,
              ),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(state.order.createdAt),
              style: context.textStyles.textOrderDetailsNormal(color: context.colors.textDefault),
            )
          ],
        );
      case OrderStatus.paid:
      case OrderStatus.completed:
      case OrderStatus.bankPaid:
      case OrderStatus.visited:
      case OrderStatus.unknown:
      case OrderStatus.rejected:
      case OrderStatus.expired:
        return PaidOrderWidget(state: state);
    }
  }
}
