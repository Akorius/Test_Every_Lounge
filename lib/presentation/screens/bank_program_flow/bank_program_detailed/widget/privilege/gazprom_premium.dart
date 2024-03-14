import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class GazPromPremiumPrivilege extends StatelessWidget {
  const GazPromPremiumPrivilege({
    Key? key,
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
          "Получите компенсацию стоимости проходов*",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        Text(
          " • выберите бизнес-зал"
          "\n • оплатите проход премиальной картой\n    Газпромбанка"
          "\n • получите компенсацию стоимости",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 16),
        Text(
          "*оплата пока не доступна картами Union Pay.",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 8),
        Text(
          "Компенсация стоимости прохода поступит на карту банка до конца месяца, следующем за месяцем оплаты. Подробнее — на gazprombank.ru/premium",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
      ],
    );
  }
}
