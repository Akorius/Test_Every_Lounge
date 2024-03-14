import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BackArrowButton extends StatelessWidget {
  final Color? color;
  final Function? onTap;

  const BackArrowButton({
    Key? key,
    this.color,
    this.onTap,
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
          AppImages.arrowBack,
          color: context.colors.appBarBackArrowColor,
        ),
      ),
      onPressed: () {
        onTap?.call() ?? GoRouter.of(context).pop();
      },
    );
  }
}
