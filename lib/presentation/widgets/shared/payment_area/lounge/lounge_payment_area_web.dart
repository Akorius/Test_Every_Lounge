import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/no_card/no_card_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/online_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/passes/passes_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/recurrent/recurrent_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/tinkoff/tinkoff_area_web.dart';
import 'package:flutter/material.dart';

class LoungePaymentAreaWeb extends StatelessWidget {
  final BankCard? activeCard;
  final int passengersCount;
  final num price;
  final bool payInProgress;
  final bool canPress;
  final bool cardsLoading;
  final bool? isOnlinePayment;
  final Function()? onTinkoffPayPressed;
  final Function()? onPayWithCardPressed;
  final Function()? launchWebViewPayment;
  final Function()? onRecurrentPayPressed;
  final Function()? onUsePassPressed;
  final Function()? onAttachCardPressed;

  const LoungePaymentAreaWeb({
    Key? key,
    required this.activeCard,
    required this.passengersCount,
    required this.price,
    required this.payInProgress,
    required this.canPress,
    required this.cardsLoading,
    required this.isOnlinePayment,
    this.onTinkoffPayPressed,
    this.onPayWithCardPressed,
    this.onRecurrentPayPressed,
    this.launchWebViewPayment,
    this.onUsePassPressed,
    this.onAttachCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (activeCard?.type) {
      case BankCardType.other:
      case BankCardType.gazpromDefault:
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
      case BankCardType.moscowCredit:
      case BankCardType.raiffeisen:
      case BankCardType.otkrytie:
      case BankCardType.alfaPrem:
        return RecurrentAreaWeb(
          canPress: canPress,
          loading: payInProgress,
          passesCount: passengersCount,
          price: price,
          activeCard: activeCard!,
          onRecurrentPayPressed: onRecurrentPayPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
        return activeCard?.cardForPaymentByPasses == true && isOnlinePayment == false
            ? PassesArea(
                canPress: canPress,
                canPayByPass: true,
                loading: payInProgress,
                passengersCount: passengersCount,
                passesLeftCount: activeCard?.passesCount ?? 0,
                onUsePassPress: onUsePassPressed ?? () {},
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
                isTinkoff: true)
            : TinkoffAreaWeb(
                price: price,
                canPress: canPress,
                passesCount: passengersCount,
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
                loading: payInProgress,
              );
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
      case BankCardType.alfaClub:
        return activeCard?.cardForPaymentByPasses == true && isOnlinePayment == false
            ? PassesArea(
                canPress: canPress,
                canPayByPass: (activeCard?.passesCount ?? 0) != 0,
                loading: payInProgress,
                passengersCount: passengersCount,
                passesLeftCount: activeCard?.passesCount ?? 0,
                onUsePassPress: onUsePassPressed ?? () {},
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
              )
            : OnlinePaymentArea(
                loading: payInProgress,
                passengersCount: passengersCount,
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
                price: price,
                activeCard: activeCard,
              );
      case null:
        return NoCardAreaWeb(
          canPress: canPress,
          loading: payInProgress,
          passesCount: passengersCount,
          price: price,
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
    }
  }
}
