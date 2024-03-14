import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/alfa/alfa_pay_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/no_card/no_card_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/online_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/recurrent/recurrent_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/tinkoff/tinkoff_area_mob.dart';
import 'package:flutter/material.dart';

class PremiumPaymentArea extends StatelessWidget {
  final BankCard? activeCard;
  final num price;
  final bool payInProgress;
  final bool canPress;
  final bool cardsLoading;
  final Function()? onTinkoffPayPressed;
  final Function()? onAlfaPayPressed;
  final Function()? onPayWithCardPressed;
  final Function()? onRecurrentPayPressed;
  final Function()? onUsePassPressed;
  final Function()? onAttachCardPressed;

  const PremiumPaymentArea({
    Key? key,
    required this.activeCard,
    required this.price,
    required this.payInProgress,
    required this.canPress,
    required this.cardsLoading,
    this.onTinkoffPayPressed,
    this.onAlfaPayPressed,
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
      case BankCardType.otkrytie:
        return RecurrentAreaMob(
          canPress: canPress,
          loading: payInProgress,
          price: price,
          activeCard: activeCard!,
          onRecurrentPayPressed: onRecurrentPayPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
        return TinkoffArea(
          price: price,
          canPress: canPress,
          loading: payInProgress,
          onTinkoffPayPressed: onTinkoffPayPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
      case BankCardType.alfaPrem:
        return AlfaPayArea(
          canPress: canPress,
          loading: payInProgress,
          price: price,
          onAflaPayPressed: onAlfaPayPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
      case BankCardType.alfaClub:
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
        return OnlinePaymentArea(
            canPress: price > 0.0 ? true : false,
            loading: payInProgress,
            onPayWithCardPressed: () => onPayWithCardPressed?.call(),
            price: price,
            activeCard: activeCard);
      case null:
        return NoCardAreaMob(
          canPress: canPress,
          loading: payInProgress,
          price: price,
          onAttachCardPressed: onAttachCardPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
    }
  }
}
