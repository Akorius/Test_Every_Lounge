import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/no_card/no_card_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/recurrent/recurrent_area_web.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/tinkoff/tinkoff_area_web.dart';
import 'package:flutter/material.dart';

class PremiumPaymentAreaWeb extends StatelessWidget {
  final BankCard? activeCard;
  final int passengersCount;
  final num price;
  final bool payInProgress;
  final bool canPress;
  final bool cardsLoading;
  final Function()? onTinkoffPayPressed;
  final Function()? onPayWithCardPressed;
  final Function()? onRecurrentPayPressed;
  final Function()? onUsePassPressed;
  final Function()? onAttachCardPressed;

  const PremiumPaymentAreaWeb({
    Key? key,
    required this.activeCard,
    required this.passengersCount,
    required this.price,
    required this.payInProgress,
    required this.canPress,
    required this.cardsLoading,
    this.onTinkoffPayPressed,
    this.onPayWithCardPressed,
    this.onRecurrentPayPressed,
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
      case BankCardType.alfaClub:
      case BankCardType.alfaPrem:
      case BankCardType.otkrytie:
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
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
        return TinkoffAreaWeb(
          price: price,
          canPress: canPress,
          passesCount: passengersCount,
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
          loading: payInProgress,
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
