import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/widgets/inputs/code_text_field.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteWithPin extends StatelessWidget {
  final ProfileSettingsState state;

  const DeleteWithPin({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Чтобы навсегда удалить ваш аккаунт, пожалуйста введите код, высланный на ваш e-mail',
          style: context.textStyles.loginInfoButtonText(
            color: context.colors.appBarBackArrowColor,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        CodeTextField(
          onCodeChanged: (code) {},
          onCodeCompleted: (code) {
            context.read<ProfileSettingsCubit>().deleteUser(email: state.user!.email, code: code);
          },
        ),
        RegularButton(
          label: Text(
            'Отменить',
            style: context.textStyles.negativeButtonText(color: context.colors.buttonDisabledText),
          ),
          onPressed: () async {
            context.read<ProfileSettingsCubit>().toConfirmScreen(isConfirm: false);
          },
          color: context.colors.textFieldError,
        ),
        const SizedBox(
          height: 24,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Не получили код? ',
                style: AppTextStyles.textLargeRegular(
                  color: context.colors.appBarBackArrowColor,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => context.read<ProfileSettingsCubit>().deleteUser(email: state.user!.email),
                text: ' Выслать еще раз',
                style: AppTextStyles.textLargeRegular(
                  color: context.colors.textOrderDetailsImpart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
