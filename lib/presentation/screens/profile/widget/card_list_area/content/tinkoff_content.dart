import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class TinkoffContent extends StatelessWidget {
  final BankCardType cardType;
  final int? passCount;
  late final String text;

  TinkoffContent({
    super.key,
    required this.cardType,
    this.passCount,
  }) {
    switch (cardType) {
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPro:
        text = "Tinkoff";
        break;
      case BankCardType.tinkoffPremium:
        text = "Tinkoff Premium";
        break;
      case BankCardType.tinkoffPrivate:
        text = "Tinkoff Private";
        break;
      default:
        throw Exception("Неприменимый тип банка: $cardType");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: context.textStyles.textLargeBold(),
        ),
        if (passCount != null && (passCount != 0 || cardType == BankCardType.tinkoffPremium))
          Text(
            'Бизнес-залы: ${passCount == -1 ? 'Безлимит' : TextUtils.passesText(passCount!)}',
            style: context.textStyles.textSmallRegular(),
          ),
      ],
    );
  }
}
