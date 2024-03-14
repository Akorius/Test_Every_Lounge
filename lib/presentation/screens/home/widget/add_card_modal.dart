import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const showAddCardModalPath = 'showAddCardModal';

///isAlfaPrem - функционал disable к релизу 2.4.0
Future<void> showAddCardModal(BuildContext context, bool hideBanks, bool isAlfaPrem) async {
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
                  child: isAlfaPrem ? SvgPicture.asset(AppImages.cardBigCircleAlfaPrem) : Image.asset(AppImages.cardBlue),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                  child: Text(
                    textAlign: TextAlign.center,
                    isAlfaPrem ? "Добавьте карту Альфа Банка" : "Добавьте способ оплаты",
                    style: context.textStyles.h2(color: context.colors.textDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                  child: Text(
                    "для подключения ваших банковских преимуществ",
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
                      context.pop();
                      context.read<HomeCubit>().sendEvent(eventName[skipPaymentAddClick]!);
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
                    label: const Text("Продолжить"),
                    onPressed: () {
                      context.read<HomeCubit>().sendEvent(eventName[acceptAddPaymentClick]!);
                      Navigator.pop(context);
                      if (hideBanks || isAlfaPrem) {
                        context.read<HomeCubit>().attachCardCubit.openAttachCardScreen();
                      } else {
                        context.push(AppRoutes.selectPaymentMethodModal);
                      }
                    },
                    withoutElevation: true,
                    color: isAlfaPrem ? context.colors.textDefault : null,
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
