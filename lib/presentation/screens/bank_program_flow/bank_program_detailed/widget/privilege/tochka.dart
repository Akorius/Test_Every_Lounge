import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TochkaPrivilege extends StatelessWidget {
  final BankCard bankCard;

  const TochkaPrivilege({
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
          "Баланс ваших проходов: ${bankCard.passesCount}",
          style: context.textStyles.textLargeBold(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "Если вы хотите приобрести больше проходов, чем вам доступно, то вы можете пополнить баланс проходов в личном кабинете на сайте банка.",
            style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "Подробнее — на ",
              style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
            ),
            InkWell(
              onTap: () async {
                try {
                  await launchUrlString("https://tochka.com/fly");
                } catch (e, s) {
                  Log.exception(e, s, "TochkaPrivilege");
                }
              },
              child: Text(
                "tochka.com/fly",
                style: context.textStyles
                    .textSmallRegular(color: context.colors.textNormalGrey)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
