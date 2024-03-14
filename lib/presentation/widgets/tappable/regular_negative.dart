import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';

class RegularButtonNegative extends StatelessWidget {
  final bool canPress;
  final bool isLoading;
  final Function() onPressed;
  final double? width;
  final double? minWidth;
  final double height;
  final Color? colorBorder;
  final Color? colorPressed;
  final Color? backgroundColor;
  final Color? overlayColor;
  final Widget child;

  const RegularButtonNegative({
    Key? key,
    required this.child,
    required this.onPressed,
    this.canPress = true,
    this.width,
    this.height = 48,
    this.isLoading = false,
    this.colorBorder,
    this.colorPressed,
    this.minWidth,
    this.backgroundColor,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            onPressed: canPress && !isLoading ? onPressed : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: backgroundColor ?? context.colors.buttonNegative,
              disabledBackgroundColor: context.colors.buttonNegative,
              foregroundColor: context.colors.buttonNegativeText,
              disabledForegroundColor: context.colors.buttonNegativeDisabledText,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              side: BorderSide(width: 1.0, color: colorBorder ?? context.colors.buttonNegativeBorder),
              textStyle: context.textStyles.negativeButtonText(
                color: canPress ? context.colors.buttonNegativeText : context.colors.buttonNegativeDisabledText,
              ),
              elevation: 0,
              maximumSize: Size(width ?? double.infinity, height),
              minimumSize: Size(minWidth ?? 0, height),
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
            ).copyWith(
              overlayColor: MaterialStatePropertyAll(overlayColor ?? context.colors.buttonNegativePressed),
            ),
            child: isLoading ? const AppCircularProgressIndicator() : child)
      ],
    );
  }
}
