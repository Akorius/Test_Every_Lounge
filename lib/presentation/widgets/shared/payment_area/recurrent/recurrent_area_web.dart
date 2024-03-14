import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

import '../passes/passes_counter.dart';
import '../payment_area_decoration.dart';

class RecurrentAreaWeb extends StatelessWidget {
  final int passesCount;
  final num price;
  final BankCard activeCard;
  final bool canPress;
  final bool loading;
  final Function() onRecurrentPayPressed;
  final Function() onPayWithCardPressed;

  const RecurrentAreaWeb({
    Key? key,
    required this.canPress,
    required this.loading,
    required this.passesCount,
    required this.price,
    required this.activeCard,
    required this.onRecurrentPayPressed,
    required this.onPayWithCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonAreaDecoration(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 27),
      child: Column(
        children: [
          PassesCounter(
            price: price,
            passesCount: passesCount,
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
          RegularButton(
            label: const Text("Оплатить"),
            onPressed: onRecurrentPayPressed,
            canPress: canPress,
            isLoading: loading,
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: canPress ? onPayWithCardPressed : null,
            child: Text(
              "Оплатить банковской картой",
              style: context.textStyles.textNormalRegularLink(),
            ),
          ),
        ],
      ),
    );
  }
}
