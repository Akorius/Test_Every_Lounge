import 'package:everylounge/presentation/widgets/shared/payment_area/passes/passes_counter.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/pay_by_card.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/total.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

class NoCardAreaMob extends StatelessWidget {
  final int? passesCount;
  final num price;
  final bool canPress;
  final bool loading;
  final Function() onAttachCardPressed;
  final Function() onPayWithCardPressed;
  final String? title;

  const NoCardAreaMob({
    Key? key,
    required this.canPress,
    required this.loading,
    this.passesCount,
    required this.price,
    required this.onAttachCardPressed,
    required this.onPayWithCardPressed,
    this.title,
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
                  title: title,
                  price: price,
                ),
          const SizedBox(height: 8),
          RegularButton(
            onPressed: onAttachCardPressed,
            canPress: true,
            isLoading: loading,
            label: const Text("Привязать карту"),
          ),
          PayByCard(onPayWithCardPressed: onPayWithCardPressed)
        ],
      ),
    );
  }
}
