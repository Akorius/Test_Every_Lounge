import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OnlinePaymentArea extends StatelessWidget {
  final int passengersCount;
  final bool loading;
  final Function() onPayWithCardPressed;
  final num price;
  final bool canPress;
  final BankCard? activeCard;

  const OnlinePaymentArea({
    Key? key,
    required this.loading,
    this.passengersCount = 0,
    required this.onPayWithCardPressed,
    required this.price,
    required this.activeCard,
    this.canPress = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonAreaDecoration(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: PlatformWrap.isIOS ? 21 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (passengersCount != 0) ...[
                    Text(
                      "${TextUtils.passesText(passengersCount)} x ${NumberFormat.decimalPattern('ru').format(price)}",
                      style: context.textStyles.textLargeRegular(
                        color: context.colors.textOrderDetailsTitle,
                        ruble: true,
                      ),
                    ),
                    Text(
                      " ₽",
                      style: context.textStyles.textLargeRegular(
                        color: context.colors.textOrderDetailsTitle,
                        ruble: true,
                      ),
                    ),
                  ] else
                    Text(
                      'Итого',
                      style: context.textStyles.textLargeRegular(
                        color: context.colors.textOrderDetailsTitle,
                        ruble: true,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${passengersCount != 0 ? passengersCount * price : price}",
                    style: context.textStyles.textLargeBold(
                      color: context.colors.buttonPressed,
                    ),
                  ),
                  Text(
                    " ₽",
                    style: PlatformWrap.isAndroid
                        ? TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: context.colors.textOrderDetailsTitle,
                          )
                        : context.textStyles.textLargeBold(color: context.colors.buttonPressed, ruble: true),
                  ),
                ],
              ),
            ],
          ),
          if (activeCard?.cardForPaymentByPasses == false)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BankProgramLogo(bankCard: activeCard),
            ),
          const SizedBox(height: 8),
          RegularButton(
            label: const Text("Оплатить банковской картой"),
            onPressed: () => onPayWithCardPressed.call(),
            canPress: canPress,
            isLoading: loading,
          ),
        ],
      ),
    );
  }
}
