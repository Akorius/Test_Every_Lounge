import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

Future<void> showSuccessRemoveAccountModal(BuildContext context) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ModalTopElement(),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(AppImages.success),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                child: Text(
                  "Ваш аккаунт успешно удален",
                  textAlign: TextAlign.center,
                  style: context.textStyles.header700(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
                child: RegularButtonNegative(
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: const Text("Понятно"),
                ),
              )
            ],
          ),
        ],
      );
    },
  );
}
