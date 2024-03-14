import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TinkoffDefaultPrivilege extends StatelessWidget {
  const TinkoffDefaultPrivilege({Key? key}) : super(key: key);

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
          "Не платите за вход в бизнес-зал с Tinkoff Premium",
          style: context.textStyles.textLargeBold(),
        ),
        const SizedBox(height: 8),
        Text(
          "Сейчас посещение залов платное, но с премиум-сервисом вас ждут привилегии:",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
        Text(
          " • Бесплатно от 2 проходов в бизнес-залы каждый месяц",
          style: context.textStyles.textNormalRegular(),
        ),
        const SizedBox(height: 8),
        Text(
          " • Страховка на 5 человек",
          style: context.textStyles.textNormalRegular(),
        ),
        Text(
          "    для активного отдыха по всему миру.",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 8),
        Text(
          " • Кэшбэк до 60 000 рублей",
          style: context.textStyles.textNormalRegular(),
        ),
        Text(
          "    или миль в месяц за покупки.",
          style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            try {
              await launchUrlString("tinkoffbank://Main/TbundleCoreDetails?coreCode=premium");
            } catch (e, s) {
              Log.exception(e, s, "TinkoffPrivileges");
            }
          },
          child: Text(
            "Смотреть все привилегии",
            style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled),
          ),
        ),
      ],
    );
  }
}
