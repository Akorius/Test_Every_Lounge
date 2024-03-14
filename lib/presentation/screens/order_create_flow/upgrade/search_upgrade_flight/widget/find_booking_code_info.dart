import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

void showFindBookingCodeInfoModal(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 56),
                  child: Text(
                    "Где найти код бронирования\nили PNR?",
                    textAlign: TextAlign.center,
                    style: context.textStyles.h2(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                  child: Text(
                    "Идентификатор брони из 6 знаков вы можете найти в маршрутной квитанции, отправленной вам по электронной почте после бронирования.",
                    textAlign: TextAlign.center,
                    style: context.textStyles.textNormalRegular(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 40),
                  child: RegularButtonNegative(
                    minWidth: MediaQuery.of(context).size.width,
                    child: const Text("Понятно"),
                    onPressed: () => Navigator.pop(buildContext),
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
