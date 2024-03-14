import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/alfa/alfa_pay_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/no_card/no_card_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/online_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/passes/passes_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/recurrent/recurrent_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/tinkoff/tinkoff_area_mob.dart';
import 'package:flutter/material.dart';

class LoungePaymentArea extends StatelessWidget {
  final BankCard? activeCard;
  final int passengersCount;
  final num price;
  final bool payInProgress;
  final bool canPress;
  final bool? isOnlinePayment;
  final Function()? onTinkoffPayPressed;
  final Function()? onAlfaPayPressed;
  final Function()? onPayWithCardPressed;
  final Function()? onRecurrentPayPressed;
  final Function()? onUsePassPressed;
  final Function()? onAttachCardPressed;

  const LoungePaymentArea({
    Key? key,
    required this.activeCard,
    required this.passengersCount,
    required this.price,
    required this.payInProgress,
    required this.canPress,
    this.onTinkoffPayPressed,
    this.onPayWithCardPressed,
    this.onRecurrentPayPressed,
    this.onUsePassPressed,
    this.onAttachCardPressed,
    this.isOnlinePayment,
    this.onAlfaPayPressed,
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
          passesCount: passengersCount,
          price: price,
          activeCard: activeCard!,
          onRecurrentPayPressed: onRecurrentPayPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
      case BankCardType.alfaPrem:
        return AlfaPayArea(
          canPress: canPress,
          loading: payInProgress,
          passesCount: passengersCount,
          price: price,
          onAflaPayPressed: onAlfaPayPressed ?? () {},
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
            : TinkoffArea(
                price: price,
                canPress: canPress,
                loading: payInProgress,
                passesCount: passengersCount,
                onTinkoffPayPressed: onTinkoffPayPressed ?? () {},
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
              );
      case BankCardType.beelineKZ:
      case BankCardType.tochka:
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
                canPress: canPress,
                loading: payInProgress,
                passengersCount: passengersCount,
                price: price,
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
                activeCard: activeCard,
              );
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
            : AlfaPayArea(
                canPress: canPress,
                loading: payInProgress,
                passesCount: passengersCount,
                price: price,
                onAflaPayPressed: onAlfaPayPressed ?? () {},
                onPayWithCardPressed: onPayWithCardPressed ?? () {},
              );
      case null:
        return NoCardAreaMob(
          canPress: canPress,
          loading: payInProgress,
          passesCount: passengersCount,
          price: price,
          onAttachCardPressed: onAttachCardPressed ?? () {},
          onPayWithCardPressed: onPayWithCardPressed ?? () {},
        );
    }
  }
}
