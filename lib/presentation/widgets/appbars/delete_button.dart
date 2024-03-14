import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteButton extends StatelessWidget {
  final Color? color;
  final Function() onPressed;

  const DeleteButton({
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
            border: Border.all(
              color: color ?? context.colors.iconUnselected,
            )),
        child: SvgPicture.asset(
          AppImages.bucket,
          color: context.colors.iconUnselected,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
