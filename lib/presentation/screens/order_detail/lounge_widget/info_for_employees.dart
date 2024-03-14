import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoForEmployees extends StatelessWidget {
  const InfoForEmployees({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Text(
              "В случае появления вопросов со стороны сотрудника Бизнес-зала покажите ему Note for Business Lounge’s employees (ниже).",
              textAlign: TextAlign.center,
              style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: context.colors.buttonEnabled,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.info,
                  color: context.colors.buttonEnabled,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Note for Business Lounge’s employees",
                    style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled),
                  ),
                ),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(AppImages.arrowRight, color: context.colors.buttonEnabled)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
