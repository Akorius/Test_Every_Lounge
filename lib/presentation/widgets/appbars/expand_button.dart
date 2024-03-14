import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpanderButton extends StatelessWidget {
  final Color? color;
  final Function() onPressed;

  const ExpanderButton({
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
        padding: const EdgeInsets.all(9),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color ?? context.colors.appBarBackArrowBackground,
          borderRadius: BorderRadius.circular(40),
        ),
        child: SvgPicture.asset(
          AppImages.increase,
          color: context.colors.textDefault,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
