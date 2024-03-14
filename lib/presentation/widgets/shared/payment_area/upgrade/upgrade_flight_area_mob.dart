import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/alfa/alfa_pay_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/no_card/no_card_area_mob.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/online_payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/pay_by_card.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/tinkoff/tinkoff_area_mob.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpgradeFlightAreaMob extends StatelessWidget {
  final num price;
  final BankCard? activeCard;
  final bool canPress;
  final bool loading;
  final Function? onRecurrentPayPressed;
  final Function? onPayWithCardPressed;
  final Function? onTinkoffPayPressed;
  final Function? onAlfaPayPressed;
  final Function? onAttachCardPressed;

  const UpgradeFlightAreaMob({
    Key? key,
    required this.canPress,
    required this.loading,
    required this.price,
    required this.activeCard,
    required this.onRecurrentPayPressed,
    required this.onPayWithCardPressed,
    required this.onTinkoffPayPressed,
    required this.onAlfaPayPressed,
    required this.onAttachCardPressed,
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
        return BankCardPayment(
          title: getTitle(),
          price: price,
          activeCard: activeCard,
          canPress: canPress,
          isLoading: loading,
          onRecurrentPayPressed: onRecurrentPayPressed,
          onPayWithCardPressed: onPayWithCardPressed,
        );
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
        return TinkoffArea(
          price: price,
          canPress: canPress,
          loading: loading,
          onTinkoffPayPressed: () => onTinkoffPayPressed?.call(),
          onPayWithCardPressed: () => onPayWithCardPressed?.call(),
          title: getTitle(),
        );
      case BankCardType.alfaPrem:
        return AlfaPayArea(
          canPress: canPress,
          loading: loading,
          price: price,
          onAflaPayPressed: () => onAlfaPayPressed ?? () {},
          onPayWithCardPressed: () => onPayWithCardPressed ?? () {},
        );
      case BankCardType.alfaClub:
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
        return OnlinePaymentArea(
            canPress: canPress,
            loading: loading,
            onPayWithCardPressed: () => onPayWithCardPressed?.call(),
            price: price,
            activeCard: activeCard);
      case null:
        return NoCardAreaMob(
            canPress: canPress,
            loading: loading,
            price: price,
            onAttachCardPressed: () => onAttachCardPressed?.call(),
            onPayWithCardPressed: () => onPayWithCardPressed?.call(),
            title: getTitle());
    }
  }

  String getTitle() => price > 0 ? 'Повышение класса' : 'Выберите пассажиров';
}

class BankCardPayment extends StatelessWidget {
  const BankCardPayment({
    required this.title,
    required this.price,
    required this.activeCard,
    required this.canPress,
    required this.isLoading,
    required this.onRecurrentPayPressed,
    required this.onPayWithCardPressed,
    super.key,
  });

  final num price;
  final BankCard? activeCard;
  final String title;
  final bool canPress;
  final bool isLoading;
  final Function? onRecurrentPayPressed;
  final Function? onPayWithCardPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.dividerGray,
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          ButtonAreaDecoration(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
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
                ),
                const SizedBox(height: 8),
                if (isRealCard())
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 78,
                          child: BankProgramLogo(bankCard: activeCard, color: context.colors.textDefault),
                        ),
                        Text(
                          activeCard!.maskedNumber
                              .substring(activeCard!.maskedNumber.length - 6, activeCard!.maskedNumber.length)
                              .padLeft(5),
                          style: context.textStyles.textNormalRegular(),
                        )
                      ],
                    ),
                  ),
                RegularButton(
                  label: const Text("Оплатить"),
                  onPressed: () => isRealCard() ? onRecurrentPayPressed?.call() : onPayWithCardPressed?.call(),
                  canPress: canPress,
                  isLoading: isLoading,
                  color: context.colors.buttonEnabled,
                  disabledColor: context.colors.buttonEnabled.withOpacity(0.3),
                ),
                PayByCard(onPayWithCardPressed: onPayWithCardPressed)
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isRealCard() => activeCard != null && !(activeCard!.fake ?? false);
}
