import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/about_app.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/account/account.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/account_settings.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/developer.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/permission.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/rules.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/settings_app_bar.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingProfileScreen extends StatelessWidget {
  static const path = "settings";

  const SettingProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<ProfileSettingsCubit>();
    return CommonScaffold(
      messageStream: bloc.messageStream,
      onMessage: (message) async {
        if (message == ProfileSettingsState.logoutEvent) {
          context.go(AppRoutes.loginBottomNavigation);
        } else {
          context.showSnackbar(message);
        }
      },
      backgroundColor: context.colors.backgroundColor,
      appBar: const SettingsProfileAppBar(title: 'Настройки'),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Account(),
          if (!PlatformWrap.isWeb) const Permission(),
          const Rules(),
          const AboutApp(),
          BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
            builder: (context, state) {
              return state.isDeveloper ? Developer(state: state) : const SizedBox();
            },
          ),
          const AccountSettings(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: InkWell(
                onTap: () => context.read<ProfileSettingsCubit>().logOut(),
                child: Text(
                  'Выйти из аккаунта',
                  style: context.textStyles.textLargeBold(
                    color: context.colors.textFieldError,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
