import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

void showTinkoffMailSheet(BuildContext context) {
  showModalBottomSheet(
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
              const SizedBox(height: 16),
              Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: context.colors.cardSelectedBorder,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(AppImages.emailLogo),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                child: Text(
                  "Для того что бы поменять ваш email нужно обратиться в службу Тинькофф",
                  style: AppTextStyles.h2(color: context.colors.textDefault),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                child: Text(
                  "Если Тинькофф поменял ваш email, но он не отображается в приложении, то нужно его перезагрузить",
                  style: context.textStyles.textLargeRegular(color: context.colors.iconUnselected),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 47,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: context.colors.buttonEnabledText,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: context.colors.buttonDisabled),
                  ),
                  child: Center(
                    child: Text(
                      'Понятно',
                      style: context.textStyles.negativeButtonText(color: context.colors.buttonPressed),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ],
      );
    },
  );
}
