import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area.dart';
import 'package:flutter/material.dart';

class BottomOrderStatusAreaPayment extends StatelessWidget {
  final OrderDetailsState state;
  final Function() onTinkoffPayPressed;
  final Function() onAlfaPayPressed;
  final Function() onPayWithCardPressed;
  final Function() onRecurrentPayPressed;
  final Function() onAttachCardPressed;
  final Function()? onUsePassPressed;
  final bool? canPress;
  final num price;
  final bool? isOnlinePayment;

  const BottomOrderStatusAreaPayment({
    Key? key,
    required this.state,
    required this.onTinkoffPayPressed,
    required this.onAlfaPayPressed,
    required this.onPayWithCardPressed,
    required this.onRecurrentPayPressed,
    required this.onAttachCardPressed,
    this.onUsePassPressed,
    this.canPress,
    required this.price,
    this.isOnlinePayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state.order.status) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentButtonArea(
              isOnlinePayment: isOnlinePayment,
              activeCard: state.activeCard,
              passengersCount: state.order.passengers.length,
              price: price,
              payInProgress: state.payInProgress || state.attachingCard,
              canPress: canPress ?? true,
              cardsLoading: state.cardsLoading,
              onTinkoffPayPressed: onTinkoffPayPressed,
              onAlfaPayPressed: onAlfaPayPressed,
              onPayWithCardPressed: onPayWithCardPressed,
              onRecurrentPayPressed: onRecurrentPayPressed,
              onAttachCardPressed: onAttachCardPressed,
              orderType: state.order.type ?? OrderType.lounge,
              onUsePassPressed: onUsePassPressed,
            ),
            if (PlatformWrap.isIOS)
              Container(
                height: MediaQuery.of(context).padding.bottom / 2,
                width: MediaQuery.of(context).size.width,
                color: context.colors.cardBackground,
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
      case OrderStatus.cancelled:
        return const SizedBox.shrink();
    }
  }
}
