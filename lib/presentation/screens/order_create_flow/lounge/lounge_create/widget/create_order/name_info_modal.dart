import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

void showNameInfoModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ModalTopElement(),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
              child: Text(
                "Имя автоматически указывается латиницей",
                style: context.textStyles.h2(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
              child: Text(
                "По правилам авиации расхождение с данными паспорта может составлять до 4 знаков.",
                style: context.textStyles.textNormalRegular(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 20),
              child: RegularButtonNegative(
                height: 54,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text("Понятно"),
                onPressed: () => Navigator.pop(buildContext),
              ),
            ),
          ],
        ),
      );
    },
  );
}
