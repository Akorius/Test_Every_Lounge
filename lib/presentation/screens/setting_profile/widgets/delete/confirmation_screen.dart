import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/delete_with_pin.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/reasons_block.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/delete/success_remove_account_modal.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/settings_app_bar.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../state.dart';

class ConfirmationDeleteScreen extends StatelessWidget {
  static const path = "confirmationDelete";

  const ConfirmationDeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<ProfileSettingsCubit>();
    return CommonScaffold(
      messageStream: bloc.messageStream,
      onMessage: (message) async {
        if (message == ProfileSettingsState.successRemoveAccount) {
          await showSuccessRemoveAccountModal(context);
          bloc.logOut();
        } else if (message == ProfileSettingsState.logoutEvent) {
          context.go(AppRoutes.loginBottomNavigation);
        } else {
          context.showSnackbar(message);
        }
      },
      backgroundColor: context.colors.backgroundColor,
      appBar: const SettingsProfileAppBar(title: 'Удаление аккаунта'),
      child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
        builder: (context, state) {
          return !state.isLoading
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: !state.isConfirm ? ReasonsBlock(state: state) : DeleteWithPin(state: state),
                )
              : const Center(child: AppCircularProgressIndicator.large());
        },
      ),
    );
  }
}
