import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

void showPayByPassModal(
  BuildContext context, {
  required Function callback,
  required int count,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return SafeArea(
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ModalTopElement(),
                const SizedBox(height: 26),
                Text(
                  textAlign: TextAlign.center,
                  "Подтвердите оформление\nпроходов в бизнес-зал",
                  style: context.textStyles.h2(color: context.colors.textDefault),
                ),
                const SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.center,
                  "Будет списано: ${TextUtils.passesText(count)}",
                  style: context.textStyles.textNormalRegular(color: context.colors.textDefault),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: RegularButtonNegative(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => Navigator.pop(buildContext),
                    child: const Text("Отменить"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: PlatformWrap.isIOS ? 21 : 8),
                  child: RegularButton(
                    label: const Text("Подтвердить"),
                    onPressed: () => {
                      Navigator.pop(buildContext),
                      callback.call(),
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
