import 'package:everylounge/core/config.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpgradeFlightAreaWeb extends StatelessWidget {
  final num price;
  final BankCard? activeCard;
  final bool canPress;
  final bool loading;
  final Function() onRecurrentPayPressed;
  final Function() onTinkoffPayPressed;
  final Function() onPayWithCardPressed;

  const UpgradeFlightAreaWeb({
    Key? key,
    required this.canPress,
    required this.loading,
    required this.price,
    required this.activeCard,
    required this.onRecurrentPayPressed,
    required this.onTinkoffPayPressed,
    required this.onPayWithCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonAreaDecoration(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price > 0 ? 'Повышение класса' : 'Выберите пассажиров',
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
          const SizedBox(height: 16),
          if (commonBuild && activeCard?.type != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
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
          ],
          RegularButton(
            label: const Text("Оплатить"),
            onPressed: alfaBuild ? onPayWithCardPressed : onRecurrentPayPressed,
            canPress: canPress,
            isLoading: loading,
            color: alfaBuild ? context.colors.buttonEnabledAlfa : context.colors.buttonEnabled,
            disabledColor: alfaBuild ? context.colors.buttonDisabledAlfa : context.colors.buttonEnabled.withOpacity(0.3),
          )
        ],
      ),
    );
  }
}
