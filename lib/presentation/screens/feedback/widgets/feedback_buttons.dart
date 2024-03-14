import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedbackButtons extends StatelessWidget {
  const FeedbackButtons({Key? key, this.onTap, this.leading, required this.title, this.trailing}) : super(key: key);

  final Function()? onTap;
  final String? leading;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.buttonInfoText),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
            leading: SvgPicture.asset(leading ?? ''),
            title: Transform.translate(
              offset: const Offset(-20, 0),
              child: Text(
                title!,
                style: context.textStyles.negativeButtonText(color: context.colors.buttonPressedText),
              ),
            ),
            trailing: trailing),
      ),
    );
  }
}
