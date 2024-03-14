import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

void showAddPhotoModal(
  BuildContext context, {
  required Function callbackAddPhoto,
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
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: RegularButton(
                    label: const Text("Загрузить фото"),
                    onPressed: () => {
                      Navigator.pop(buildContext),
                      callbackAddPhoto.call(),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                  child: RegularButtonNegative(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => Navigator.pop(buildContext),
                    child: const Text("Отмена"),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}
