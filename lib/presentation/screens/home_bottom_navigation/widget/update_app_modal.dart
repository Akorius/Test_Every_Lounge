import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showUpdateAppModal(
  BuildContext context,
  Function updateCallback,
) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return SafeArea(
        top: false,
        left: false,
        right: false,
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ModalTopElement(),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(AppImages.updateAppRefresh),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Доступно обновление",
                    style: context.textStyles.h2(color: context.colors.textDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                  child: Text(
                    "Мы сделали приложение быстрее и удобнее, рекомендуем обновить до последней версии",
                    textAlign: TextAlign.center,
                    style: context.textStyles.textLargeRegular(color: context.colors.textDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: RegularButtonNegative(
                    height: 54,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      context.read<HomeBottomNavigationCubit>().sendEvent(eventName[skipUpdateClick]!);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "В другой раз",
                      style: context.textStyles.negativeButtonText(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                  child: RegularButton(
                    label: const Text("Обновить"),
                    onPressed: () {
                      updateCallback.call();
                      context.read<HomeBottomNavigationCubit>().sendEvent(eventName[acceptUpdateClick]!);
                      Navigator.pop(context);
                    },
                    withoutElevation: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  return;
}
