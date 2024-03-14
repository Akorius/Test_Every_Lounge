import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ReasonsBlock extends StatelessWidget {
  final ProfileSettingsState state;

  const ReasonsBlock({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Нам очень жаль, что вы решили навсегда удалить свой аккаунт. Пожалуйста, расскажите нам о причинах вашего решения:',
          style: context.textStyles.loginInfoButtonText(
            color: context.colors.appBarBackArrowColor,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              'Выберите причину',
              style: context.textStyles.textLargeRegular(color: context.colors.iconUnselected),
              overflow: TextOverflow.ellipsis,
            ),
            items: state.reasons!
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: context.textStyles.textLargeRegular(color: context.colors.appBarBackArrowColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: state.reasonValue,
            onChanged: (newReason) {
              context.read<ProfileSettingsCubit>().chooseReason(reason: newReason);
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.only(left: 6, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colors.buttonDisabled,
                  ),
                  color: context.colors.buttonEnabledText),
            ),
            iconStyleData: IconStyleData(
              icon: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  AppImages.arrowRight,
                  height: 16,
                ),
              ),
              iconSize: 14,
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: context.colors.buttonEnabledText,
                ),
                elevation: 2,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(6),
                  thumbVisibility: MaterialStateProperty.all(true),
                )),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            context.read<ProfileSettingsCubit>().toConfirmScreen(isConfirm: true);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: context.colors.buttonEnabledText,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: context.colors.buttonDisabled),
            ),
            child: Center(
              child: Text(
                'Продолжить',
                style: context.textStyles.negativeButtonText(color: context.colors.textFieldError),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        RegularButton(
          label: Text(
            'Отменить',
            style: context.textStyles.negativeButtonText(color: context.colors.buttonDisabledText),
          ),
          onPressed: () async {
            context.pop();
          },
        ),
      ],
    );
  }
}
