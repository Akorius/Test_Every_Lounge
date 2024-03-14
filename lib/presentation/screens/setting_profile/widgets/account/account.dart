import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/account/change_data_alert_dialog.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/account/tinkoff_mail_sheet.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
      builder: (context, state) {
        return !state.isLoading
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Аккаунт',
                          style: context.textStyles.negativeButtonText(
                            color: context.colors.buttonPressed,
                          ),
                        ),
                        state.user!.authType == AuthType.tinkoff
                            ? InkWell(
                                onTap: () {
                                  showTinkoffMailSheet(context);
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: context.colors.buttonPressed,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DefaultTextField(
                            controller: emailController..text = state.user?.email ?? "",
                            keyboardType: TextInputType.emailAddress,
                            errorText: state.emailError,
                            enabled: false,
                            onChanged: (String newEmail) {
                              emailController.text = newEmail;
                              emailController.selection =
                                  TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
                            },
                            suffixIcon: Container(
                              padding: state.user!.authType == AuthType.alfa ? const EdgeInsets.only(right: 10) : null,
                              alignment: Alignment.center,
                              width: 5,
                              child: SvgPicture.asset(
                                AuthTypeExt.logos(state.user!.authType.index),
                                height: 24,
                                width: 24,
                              ),
                            ),
                            onSubmitted: (String newEmail) {
                              context.read<ProfileSettingsCubit>().changeEmail(email: newEmail);
                            },
                            onEditingComplete: () {
                              context.read<ProfileSettingsCubit>().changeEmail(email: emailController.text);
                            },
                            hint: 'email',
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AccountTextField(
                            isEnable: true,
                            controller: nameController,
                            hint: 'Имя',
                            defaultText: state.user?.profile.firstName ?? "",
                            onTap: (text) => context.read<ProfileSettingsCubit>().updateUser(firstName: text),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AccountTextField(
                            isEnable: true,
                            controller: lastNameController,
                            hint: 'Фамилия',
                            defaultText: state.user?.profile.lastName ?? "",
                            onTap: (text) => context.read<ProfileSettingsCubit>().updateUser(lastName: text),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AccountTextField(
                              isEnable: true,
                              controller: phoneController,
                              hint: 'Номер телефона',
                              defaultText: state.user?.profile.phone ?? "",
                              onTap: (text) => context.read<ProfileSettingsCubit>().updateUser(phone: text),
                              inputType: TextInputType.phone),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: AppCircularProgressIndicator(),
              );
      },
    );
  }
}

class AccountTextField extends StatelessWidget {
  const AccountTextField({
    super.key,
    required this.controller,
    required this.onTap,
    required this.hint,
    required this.defaultText,
    required this.isEnable,
    this.inputType,
  });

  final TextEditingController controller;
  final Function(String) onTap;
  final String hint;
  final String defaultText;
  final TextInputType? inputType;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isEnable
            ? showChangeDataDialog(
                context,
                controller: controller,
                onPressed: () => onTap.call(controller.text),
                title: hint,
              )
            : null;
      },
      child: IgnorePointer(
        child: DefaultTextField(
          controller: controller..text = defaultText,
          keyboardType: inputType ?? TextInputType.name,
          enabled: isEnable,
          onChanged: (String newName) {},
          hint: hint,
        ),
      ),
    );
  }
}
