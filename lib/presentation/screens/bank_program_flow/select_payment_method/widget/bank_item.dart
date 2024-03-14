import 'package:everylounge/domain/entities/bank/selected_bank.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/widget/alfa_item.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/widget/alfa_prem_item.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/widget/bank_card_item.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/widget/beeline_kz_item.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/select_payment_method/widget/tochka_item.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BankItem extends StatelessWidget {
  final PaymentMethod method;
  final PaymentMethod? methodInHandle;
  final Function() onPressed;
  final double height;
  late final Widget child;

  BankItem({
    super.key,
    required this.onPressed,
    required this.method,
    required this.methodInHandle,
    this.height = 64,
  }) {
    switch (method) {
      case PaymentMethod.tinkoff:
        child = SvgPicture.asset(AppImages.tinkoffPayLogo2);
        break;
      case PaymentMethod.bankCard:
        child = const BankCardItem();
        break;
      case PaymentMethod.tochka:
        child = const TochkaItem();
        break;
      case PaymentMethod.beelineKZ:
        child = const BeelineKZItem();
        break;
      case PaymentMethod.alfa:
        child = const AlfaItem();
        break;
      case PaymentMethod.alfaPrem:
        child = const AlfaPremItem();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: context.colors.cardBackground,
      highlightColor: context.colors.buttonNegativePressed,
      splashColor: context.colors.buttonNegativePressed,
      highlightElevation: 0,
      elevation: 0.5,
      padding: const EdgeInsets.all(12),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      height: height,
      minWidth: double.infinity,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child,
          (method == methodInHandle)
              ? const AppCircularProgressIndicator(
                  size: 25,
                )
              : SvgPicture.asset(
                  AppImages.chevron,
                  color: context.colors.textNormalGrey,
                )
        ],
      ),
    );
  }
}
