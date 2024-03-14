import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

import '../passes/passes_counter.dart';
import '../payment_area_decoration.dart';

class NoCardAreaWeb extends StatelessWidget {
  final int passesCount;
  final num price;
  final bool canPress;
  final bool loading;
  final Function() onPayWithCardPressed;

  const NoCardAreaWeb({
    Key? key,
    required this.canPress,
    required this.loading,
    required this.passesCount,
    required this.price,
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
          const SizedBox(height: 16),
          RegularButton(
            label: const Text("Оплатить картой"),
            onPressed: onPayWithCardPressed,
            canPress: canPress,
            isLoading: loading,
          )
        ],
      ),
    );
  }
}
