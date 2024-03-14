import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SettingsProfileAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: context.colors.appBarTransparentBackgroundColor,
      title: Text(
        title,
        style: context.textStyles.negativeButtonText(color: context.colors.appBarBackArrowColor),
      ),
      centerTitle: true,
      leading: const BackArrowButton(),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
