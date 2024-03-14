import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TinkoffPremiumPrivilege extends StatelessWidget {
  const TinkoffPremiumPrivilege({Key? key}) : super(key: key);

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
          "Получайте компенсацию за 2 прохода* в бизнес-залы в каждом периоде действия Tinkoff Premium",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        Text(
          "Используйте их сами или пригласите спутника",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
        Text(
          " • 4 прохода при балансе от 3 млн. рублей",
          style: context.textStyles.textNormalRegular(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            "При балансе на счетах Тинькофф от 3 млн. рублей в прошлом периоде действия Premium",
            style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          " • Безлимитно",
          style: context.textStyles.textNormalRegular(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "При балансе на счетах Тинькофф от 10 млн. рублей в прошлом периоде действия Premium",
            style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "*Число проходов обновляется в дату продления Tinkoff Premium.",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            try {
              await launchUrlString("https://www.tinkoff.ru/help/tinkoff/premium/services/business-lounge/");
            } catch (e, s) {
              Log.exception(e, s, "TinkoffPrivileges");
            }
          },
          child: Text(
            "Подробнее",
            style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled),
          ),
        ),
      ],
    );
  }
}
