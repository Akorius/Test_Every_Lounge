import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class AlfaPrivilege extends StatelessWidget {
  final BankCard bankCard;

  const AlfaPrivilege({
    Key? key,
    required this.bankCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = bankCard.passesCount == -1 ? 'Безлимит' : TextUtils.passesText(bankCard.passesCount ?? 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Специальные условия для вас",
          style: context.textStyles.textSmallBold(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 10),
        Text(
          "Бизнес-залы: $count",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        Text(
          "Клиентам А-Клуба доступно посещение бизнес-залов и возможность пригласить до 7 гостей за один раз",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
        Text(
          "Оплата проходов не потребуется, банк позаботился об этом",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
