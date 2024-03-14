import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/cubit.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumPaymentArea extends StatelessWidget {
  const PremiumPaymentArea({
    super.key,
    required this.cost,
    required this.isLoading,
  });

  final num cost;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Стоимость услуги от ${MoneyFormatter.getFormattedCost(cost)}",
              style: context.textStyles.textLargeRegular(ruble: true),
            ),
            Text(
              " ₽",
              style: context.textStyles.textLargeRegular(ruble: true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "*cтоимость указана за 1 взрослого пассажира",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 8),
        RegularButton(
          isLoading: isLoading,
          height: 54,
          label: Text(
            "Продолжить",
            style: context.textStyles.textLargeBold(color: context.colors.textLight),
          ),
          onPressed: context.read<PremiumDetailsCubit>().onMakePassButtonPressed,
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
