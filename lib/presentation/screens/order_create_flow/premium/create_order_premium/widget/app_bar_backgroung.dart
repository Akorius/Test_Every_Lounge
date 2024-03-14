import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class AppBarBackground extends StatelessWidget {
  final double? height;

  const AppBarBackground({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        color: context.colors.profileBackgroundColor,
      ),
      height: height ?? 299,
      width: double.infinity,
    );
  }
}
