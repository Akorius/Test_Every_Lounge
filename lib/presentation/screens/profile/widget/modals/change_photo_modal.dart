import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/widget/avatar.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showChangePhotoModal(
  BuildContext context,
  User? user, {
  required Function callbackAddPhoto,
  required Function callbackRemovePhoto,
}) {
  var isDeleteState = false;
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return SafeArea(
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ModalTopElement(),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      height: 180,
                      width: 180,
                      child: Stack(
                        children: [
                          Avatar(user: user, size: 90, withBorder: false),
                          !isDeleteState
                              ? Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => {
                                      setModalState(() {
                                        isDeleteState = true;
                                      })
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: context.colors.appBarBackArrowBorder,
                                        ),
                                        shape: BoxShape.circle,
                                        color: context.colors.cardBackground,
                                      ),
                                      child: SvgPicture.asset(
                                        AppImages.trash,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child: RegularButton(
                        color: isDeleteState ? context.colors.textError : null,
                        label: Text(!isDeleteState ? "Изменить" : "Удалить"),
                        onPressed: () => {
                          Navigator.pop(buildContext),
                          isDeleteState ? callbackRemovePhoto.call() : callbackAddPhoto.call(),
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
    },
  );
}
