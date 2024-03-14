import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/passes/passes_counter.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/pay_by_card.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/total.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

class RecurrentAreaMob extends StatelessWidget {
  final int? passesCount;
  final num price;
  final BankCard activeCard;
  final bool canPress;
  final bool loading;
  final Function() onRecurrentPayPressed;
  final Function() onPayWithCardPressed;

  const RecurrentAreaMob({
    Key? key,
    required this.canPress,
    required this.loading,
    this.passesCount,
    required this.price,
    required this.activeCard,
    required this.onRecurrentPayPressed,
    required this.onPayWithCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonAreaDecoration(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        children: [
          passesCount != null
              ? PassesCounter(
                  price: price,
                  passesCount: passesCount!,
                )
              : Total(
                  price: price,
                ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BankProgramLogo(bankCard: activeCard),
              Text(
                activeCard.maskedNumber.substring(activeCard.maskedNumber.length - 8, activeCard.maskedNumber.length).padLeft(5),
                style: context.textStyles.textNormalRegular(),
              )
            ],
          ),
          const SizedBox(height: 8),
          RegularButton(
            label: const Text("Оплатить"),
            onPressed: onRecurrentPayPressed,
            canPress: canPress,
            isLoading: loading,
          ),
          PayByCard(
              onPayWithCardPressed: onPayWithCardPressed,
              text: activeCard.cardForPaymentByPasses ? null : "Оплатить другой картой")
        ],
      ),
    );
  }
}
