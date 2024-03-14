import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class ButtonAreaDecoration extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets padding;

  const ButtonAreaDecoration({
    Key? key,
    required this.child,
    this.height,
    this.width,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        color: context.colors.lightDashBorder,
      ),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          color: context.colors.cardBackground,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20,
              color: context.colors.cardShadow2,
            )
          ],
        ),
        width: width ?? double.infinity,
        child: child,
      ),
    );
  }
}
