import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/appbars/close_button.dart';
import 'package:everylounge/presentation/widgets/appbars/delete_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? backArrowColor;
  final Widget? title;
  final Function? onClosePressed;
  final Function? onDeletePressed;
  final bool hideBackButton;
  final double? verticalPadding;
  final double? rightPadding;

  const AppAppBar({
    Key? key,
    this.height = 70,
    this.backArrowColor,
    this.backgroundColor,
    this.width,
    this.title,
    this.onClosePressed,
    this.onDeletePressed,
    this.hideBackButton = false,
    this.verticalPadding,
    this.rightPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 15),
        color: backgroundColor ?? Colors.transparent,
        width: width,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Visibility(
                    visible: !hideBackButton && context.canPop(),
                    child: BackArrowButton(color: backArrowColor),
                  ),
                ),
                if (onClosePressed != null)
                  Padding(
                    padding: EdgeInsets.only(right: rightPadding ?? 16),
                    child: AppCloseButton(
                      color: backArrowColor,
                      onPressed: () => onClosePressed?.call(),
                    ),
                  ),
                if (onDeletePressed != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: DeleteButton(
                      color: backArrowColor,
                      onPressed: () => onDeletePressed?.call(),
                    ),
                  ),
              ],
            ),
            if (title != null) Center(child: title!),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(width ?? double.infinity, height);
}
