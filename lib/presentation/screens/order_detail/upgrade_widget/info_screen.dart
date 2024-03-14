import 'dart:async';

import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompleteUpgradeInfoScreen extends StatelessWidget {
  static const path = "completeUpgradeInfo";

  const CompleteUpgradeInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      messageStream: StreamController<String>().stream,
      onMessage: (message) {},
      appBar: AppAppBar(
        onClosePressed: context.pop,
        hideBackButton: true,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Информация",
              style: context.textStyles.h1(),
            ),
            const SizedBox(height: 24),
            Text(
              "Внимание!",
              style: context.textStyles.textLargeBold(),
            ),
            Text(
              "\nДанная услуга не является гарантированной."
              "\n\nПри регистрации на рейс Вам будет выдан посадочный талон в класс Эконом или класс Комфорт в соответствии с приобретенным билетом."
              "\n\nЗамена посадочного талона производится при прохождении процедуры посадки на борт воздушного судна, при наличии свободных мест в салоне соответствующего класса на момент окончания регистрации."
              "\n\nВ случае, если условий для повышения класса не будет Ваши средства будут возвращены.",
              style: context.textStyles.textLargeRegular(),
            ),
            const Spacer(),
            RegularButtonNegative(
              height: 54,
              minWidth: MediaQuery.of(context).size.width,
              child: const Text("Понятно"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
