import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppCloseButton extends StatelessWidget {
  final Color? color;
  final Function onPressed;

  const AppCloseButton({
    Key? key,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      splashRadius: 23,
      icon: Container(
        padding: const EdgeInsets.all(7),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: color ?? context.colors.appBarBackArrowBackground,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: color ?? context.colors.appBarBackArrowBorder,
            )),
        child: SvgPicture.asset(
          AppImages.close,
          width: 24,
          height: 24,
          color: context.colors.appBarBackArrowColor,
        ),
      ),
      onPressed: () => onPressed.call(),
    );
  }
}
