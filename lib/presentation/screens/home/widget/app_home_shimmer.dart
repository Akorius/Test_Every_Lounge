import 'package:everylounge/presentation/screens/home/widget/home_shimmer.dart';
import 'package:flutter/material.dart';

class AppHomeShimmer extends StatelessWidget {
  const AppHomeShimmer({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 23),
      child: HomeShimmer(
        height: height ?? 134,
      ),
    );
  }
}
