import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class PassesContent extends StatelessWidget {
  final BankCard bankCard;
  final String text;

  const PassesContent({
    super.key,
    required this.text,
    required this.bankCard,
  });

  @override
  Widget build(BuildContext context) {
    var count = bankCard.passesCount == -1 ? 'Безлимит' : TextUtils.passesText(bankCard.passesCount ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 2),
        Text(
          "Бизнес-залы: $count",
          style: context.textStyles.textSmallRegular(),
        ),
      ],
    );
  }
}
