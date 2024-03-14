import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/card_loading_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/lounge/lounge_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/lounge/lounge_payment_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/premium/premium_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/premium/premium_payment_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/upgrade/upgrade_flight_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/upgrade/upgrade_flight_area_web.dart';
import 'package:flutter/material.dart';

class PaymentButtonArea extends StatelessWidget {
  final BankCard? activeCard;
  final int passengersCount;
  final num price;
  final bool payInProgress;
  final bool canPress;
  final bool cardsLoading;
  final bool? isOnlinePayment;
  final Function()? onTinkoffPayPressed;
  final Function()? onPayWithCardPressed;
  final Function()? onRecurrentPayPressed;
  final Function()? onUsePassPressed;
  final Function()? onAttachCardPressed;
  final Function()? onAlfaPayPressed;

  final OrderType orderType;

  const PaymentButtonArea({
    Key? key,
    required this.activeCard,
    required this.passengersCount,
    required this.price,
    required this.payInProgress,
    required this.canPress,
    required this.cardsLoading,
    this.onTinkoffPayPressed,
    this.onPayWithCardPressed,
    this.onAlfaPayPressed,
    this.onRecurrentPayPressed,
    this.onUsePassPressed,
    this.onAttachCardPressed,
    this.orderType = OrderType.lounge,
    this.isOnlinePayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cardsLoading) return const CardLoadingArea();
    if (!PlatformWrap.isWeb) {
      switch (orderType) {
        case OrderType.upgrade:
          return UpgradeFlightAreaMob(
            canPress: canPress,
            loading: payInProgress,
            price: price,
            activeCard: activeCard,
            onRecurrentPayPressed: onRecurrentPayPressed ?? () {},
            onAlfaPayPressed: onAlfaPayPressed ?? () {},
            onPayWithCardPressed: onPayWithCardPressed ?? () {},
            onTinkoffPayPressed: onTinkoffPayPressed,
            onAttachCardPressed: onAttachCardPressed,
          );
        case OrderType.premium:
          return PremiumPaymentArea(
            activeCard: activeCard,
            price: price,
            payInProgress: payInProgress,
            canPress: canPress,
            cardsLoading: cardsLoading,
            onTinkoffPayPressed: onTinkoffPayPressed,
            onPayWithCardPressed: onPayWithCardPressed,
            onAlfaPayPressed: onAlfaPayPressed,
            onRecurrentPayPressed: onRecurrentPayPressed,
            onUsePassPressed: onUsePassPressed,
            onAttachCardPressed: onAttachCardPressed,
          );
        case OrderType.lounge:
        default:
          return LoungePaymentArea(
            isOnlinePayment: isOnlinePayment,
            activeCard: activeCard,
            passengersCount: passengersCount,
            price: price,
            onAlfaPayPressed: onAlfaPayPressed,
            payInProgress: payInProgress,
            canPress: canPress,
            onTinkoffPayPressed: onTinkoffPayPressed,
            onPayWithCardPressed: onPayWithCardPressed,
            onRecurrentPayPressed: onRecurrentPayPressed,
            onUsePassPressed: onUsePassPressed,
            onAttachCardPressed: onAttachCardPressed,
          );
      }
    } else {
      switch (orderType) {
        case OrderType.upgrade:
          return UpgradeFlightAreaWeb(
            canPress: canPress,
            loading: payInProgress,
            price: price,
            activeCard: activeCard,
            onRecurrentPayPressed: onRecurrentPayPressed ?? () {},
            onTinkoffPayPressed: onTinkoffPayPressed ?? () {},
            onPayWithCardPressed: onPayWithCardPressed ?? () {},
          );
        case OrderType.premium:
          return PremiumPaymentAreaWeb(
            activeCard: activeCard,
            passengersCount: passengersCount,
            price: price,
            payInProgress: payInProgress,
            canPress: canPress,
            cardsLoading: cardsLoading,
            onTinkoffPayPressed: onTinkoffPayPressed,
            onPayWithCardPressed: onPayWithCardPressed,
            onRecurrentPayPressed: onRecurrentPayPressed,
            onUsePassPressed: onUsePassPressed,
            onAttachCardPressed: onAttachCardPressed,
          );
        case OrderType.lounge:
        default:
          return LoungePaymentAreaWeb(
            isOnlinePayment: isOnlinePayment,
            activeCard: activeCard,
            passengersCount: passengersCount,
            price: price,
            payInProgress: payInProgress,
            canPress: canPress,
            cardsLoading: cardsLoading,
            onTinkoffPayPressed: onTinkoffPayPressed,
            onPayWithCardPressed: onPayWithCardPressed,
            onRecurrentPayPressed: onRecurrentPayPressed,
            onUsePassPressed: onUsePassPressed,
            onAttachCardPressed: onAttachCardPressed,
          );
      }
    }
  }
}
