import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class TinkoffPrivatePrivilege extends StatelessWidget {
  const TinkoffPrivatePrivilege({Key? key}) : super(key: key);

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
          "Для вас количество проходов в бизнес-залы не ограничено",
          style: context.textStyles.textLargeBold(),
        ),
      ],
    );
  }
}
