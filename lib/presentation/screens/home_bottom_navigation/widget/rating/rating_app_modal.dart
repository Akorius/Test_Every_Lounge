import 'package:everylounge/core/config.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/rating/rating_flag.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showRatingAppModal(
  BuildContext context,
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
                  child: Image.asset(AppImages.ratingIcon),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Насколько удобно пользоваться\nEvery Lounge?",
                    style: context.textStyles.h2(color: context.colors.textDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                  child: Text(
                    "Ваша оценка поможет нам\nсделать сервис лучше",
                    textAlign: TextAlign.center,
                    style: context.textStyles.textLargeRegular(color: context.colors.textDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 33, bottom: 54),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, RateFlag.dontShow);
                        rateMyApp.launchStore();
                      },
                      child: Image.asset(AppImages.starsGroup)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: RegularButtonNegative(
                    height: 54,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
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
                    label: Text("Оценить", style: context.textStyles.textLargeBold(color: context.colors.textLight)),
                    onPressed: () {
                      Navigator.pop(context, RateFlag.dontShow);
                      rateMyApp.launchStore();
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
  ).then(
    (rateFlag) => {
      ((rateFlag != null) && (rateFlag is RateFlag))
          ? context.read<HomeCubit>().onUpdateRateFlag(rateFlag: rateFlag)
          : context.read<HomeCubit>().onUpdateRateFlag(),
    },
  );

  return;
}
