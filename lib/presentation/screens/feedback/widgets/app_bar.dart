import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';

class FeedbackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FeedbackAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.buttonPressed,
      title: Text(
        'Поддержка',
        style: context.textStyles.h2(color: context.colors.buttonPressedText),
      ),
      centerTitle: true,
      leading: const BackArrowButton(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
