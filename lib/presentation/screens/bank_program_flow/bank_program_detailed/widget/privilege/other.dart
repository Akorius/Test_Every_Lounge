import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class NoPrivilege extends StatelessWidget {
  const NoPrivilege({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Оплачивайте бизнес залы по всему миру привязанной картой",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " • ",
              style: context.textStyles.textNormalRegular(),
            ),
            Flexible(
              child: Text(
                "Чеки за проведенные транзакции отправляются на указанный в профиле email.",
                style: context.textStyles.textNormalRegular(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " • ",
              style: context.textStyles.textNormalRegular(),
            ),
            Flexible(
              child: Text(
                "Для автоматической компенсации расходов добавьте карту одного из банков-партнеров.",
                style: context.textStyles.textNormalRegular(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
