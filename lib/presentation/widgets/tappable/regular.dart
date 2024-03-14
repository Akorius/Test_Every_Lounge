import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';

class RegularButton extends StatelessWidget {
  const RegularButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.canPress = true,
    this.width,
    this.height = 54,
    this.isLoading = false,
    this.color,
    this.disabledColor,
    this.colorPressed,
    this.textStyle,
    this.withoutElevation = false,
    this.isOutline = false,
  });

  final Widget label;
  final bool canPress;
  final bool isLoading;
  final Function() onPressed;
  final double? width;
  final double height;
  final Color? color;
  final Color? disabledColor;
  final Color? colorPressed;
  final bool withoutElevation;
  final TextStyle? textStyle;
  final bool isOutline;

  @override
  Widget build(BuildContext context) {
    var textColor = canPress ? context.colors.buttonEnabledText : context.colors.buttonDisabledText;
    return isOutline
        ? ElevatedButton(
            onPressed: canPress && !isLoading ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              side: BorderSide(width: 1, color: context.colors.buttonDisabled),
              backgroundColor: context.colors.buttonNegative,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            child: isLoading
                ? const AppCircularProgressIndicator(isRevert: true)
                : DefaultTextStyle(
                    style: textStyle?.copyWith(color: textColor) ??
                        context.textStyles.regularButtonText(
                          color: textColor,
                        ),
                    child: label,
                  ),
          )
        : MaterialButton(
            elevation: withoutElevation ? 0 : null,
            color: color ?? context.colors.buttonEnabled,
            disabledColor: disabledColor ?? context.colors.buttonDisabled,
            disabledTextColor: context.colors.buttonDisabledText,
            highlightColor: colorPressed ?? context.colors.buttonPressed,
            splashColor: colorPressed ?? context.colors.buttonPressed,
            highlightElevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            height: height,
            minWidth: width ?? double.infinity,
            onPressed: canPress && !isLoading ? onPressed : null,
            child: isLoading
                ? const AppCircularProgressIndicator(isRevert: true)
                : DefaultTextStyle(
                    style: textStyle?.copyWith(color: textColor) ??
                        context.textStyles.regularButtonText(
                          color: textColor,
                        ),
                    child: label,
                  ),
          );
  }
}
