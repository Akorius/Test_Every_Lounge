import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class BeelineKZPrivilege extends StatelessWidget {
  final BankCard bankCard;

  const BeelineKZPrivilege({
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
        SizedBox(
          height: 10,
          width: MediaQuery.of(context).size.width,
        ),
        Text(
          "Баланс ваших проходов: ${bankCard.passesCount}",
          style: context.textStyles.textLargeBold(),
        ),
      ],
    );
  }
}
