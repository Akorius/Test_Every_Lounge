import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class BankCardContent extends StatelessWidget {
  final BankCard bankCard;
  late final String program;

  BankCardContent({
    super.key,
    required this.bankCard,
  }) {
    switch (bankCard.type) {
      case BankCardType.gazpromDefault:
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
        program = "Газпромбанк Премиум";
        break;
      case BankCardType.otkrytie:
        program = "Открытие";
        break;
      case BankCardType.moscowCredit:
        program = "МКБ";
        break;
      case BankCardType.raiffeisen:
        program = "";
        break;
      case BankCardType.alfaPrem:
        program = "Альфа Премиум";
        break;
      case BankCardType.other:
        program = "Банковская карта";
        break;
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
      case BankCardType.alfaClub:
        throw Exception("Недопустимый тип карты");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program,
              style: context.textStyles.textLargeBold(),
            ),
            if (bankCard.type != BankCardType.alfaPrem) ...[
              const SizedBox(height: 2),
              Text(
                "*${(bankCard.maskedNumber).split("*").last}",
                style: context.textStyles.textSmallRegular(),
              ),
            ]
          ],
        ),
      ],
    );
  }
}
