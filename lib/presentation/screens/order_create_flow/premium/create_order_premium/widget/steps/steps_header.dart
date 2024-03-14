import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/state.dart';
import 'package:flutter/material.dart';

class StepsHeader extends StatelessWidget {
  final PremiumServiceCreateStep step;

  const StepsHeader({
    Key? key,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: StepsHeaderStep(
            title: 'Рейс',
            isSelected: step == PremiumServiceCreateStep.flight,
            isCompleted: step == PremiumServiceCreateStep.passengers || step == PremiumServiceCreateStep.payment,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: StepsHeaderStep(
            title: 'Пассажиры',
            isSelected: step == PremiumServiceCreateStep.passengers,
            isCompleted: step == PremiumServiceCreateStep.payment,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: StepsHeaderStep(
            title: 'Оплата',
            isSelected: step == PremiumServiceCreateStep.payment,
            isCompleted: false,
          ),
        ),
      ],
    );
  }
}

class StepsHeaderStep extends StatelessWidget {
  final bool isSelected;
  final bool isCompleted;
  final String title;

  const StepsHeaderStep({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.textStyles.textNormalRegular(
              color: isCompleted
                  ? context.colors.textLight
                  : isSelected
                      ? context.colors.buttonInfoText
                      : context.colors.textLight.withOpacity(0.4)),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: isCompleted
                ? context.colors.textLight
                : isSelected
                    ? context.colors.buttonInfoText
                    : context.colors.textLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
