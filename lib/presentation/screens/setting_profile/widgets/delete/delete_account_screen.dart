import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/settings_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteProfileScreen extends StatelessWidget {
  static const path = "deleteProfile";

  const DeleteProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundColor,
      appBar: const SettingsProfileAppBar(title: 'Аккаунт'),
      body: GestureDetector(
        onTap: () {
          context.push(AppRoutes.confirmationDeleteScreen);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.colors.buttonPressedText,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              'Безвозвратно удалить аккаунт',
              style: AppTextStyles.textLargeRegular(
                color: context.colors.textFieldError,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: context.colors.textNormalGrey,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
