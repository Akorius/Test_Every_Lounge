import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/unordered_list_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MkbPrivilege extends StatelessWidget {
  const MkbPrivilege({
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
          "Компенсируем вход в бизнес-зал",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 10),
        Text(
          "После оплаты посещения картой МКБ мы полностью вернем затраты на вход клиентам:",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
        const UnorderedListItem('с пакетом услуг «Эксклюзивный»'),
        const UnorderedListItem('с пакетом услуг «Премиальный»'),
        const UnorderedListItem('с зарплатной картой МКБ Премиум'),
        const SizedBox(height: 8),
        Text(
          "Обычно компенсация приходит моментально, но иногда может понадобиться до 7 рабочих дней.",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () async {
            try {
              await launchUrlString("https://mkb.ru");
            } catch (e, s) {
              Log.exception(e, s, "MKBPrivilege");
            }
          },
          child: Text.rich(
            TextSpan(
              text: "Подробнее у вашего персонального менеджера или на сайте",
              style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
              children: [
                TextSpan(
                  text: " mkb.ru",
                  style: context.textStyles
                      .textSmallRegular(color: context.colors.textNormalGrey)
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
