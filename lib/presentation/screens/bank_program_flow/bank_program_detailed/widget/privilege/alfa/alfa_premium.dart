import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/unordered_list_item_with_custom.dart';
import 'package:flutter/material.dart';

class AlfaPremiumPrivilege extends StatelessWidget {
  final BankCard bankCard;

  const AlfaPremiumPrivilege({
    Key? key,
    required this.bankCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Специальные условия для вас",
          style: context.textStyles.textSmallBold(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 10),
        Text(
          "Получайте компенсацию от Alfa Only за визиты в бизнес-залы*",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        const UnorderedListItemCustom(
            'От 3 млн ₽ на счетах или от 1,5 млн ₽ на счетах + покупки от 100 000 ₽ в месяц:', '\n2 визита в месяц, до 12 в год'),
        const UnorderedListItemCustom(
            'От 6 млн ₽ на счетах или от 3 млн ₽ + покупки от 200 000 ₽ в месяц:', '\n8 визитов в месяц, до  24 в год'),
        const UnorderedListItemCustom('От 12 млн ₽ на счетах:', ' безлимит'),
        const SizedBox(height: 8),
        Text(
          "*компенсируем до 3х гостей за один визит,\nстоимость 1 визита = 2500 ₽",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey, ruble: true),
        ),
        const SizedBox(height: 8),
        Text(
          "Клиенты А-Клуба могут бесплатно оформлять визиты в бизнес-залы. Доступное количество визитов и как ими пользоваться, можно посмотреть в приложении банка или уточнить у финансового советника.",
          style: context.textStyles.textMiniRegular(),
        ),
      ],
    );
  }
}
