import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AirportLoadingShimmer extends StatelessWidget {
  const AirportLoadingShimmer({this.itemCount, super.key});

  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount ?? 5,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: context.colors.lightDashBorder.withOpacity(0.2),
        highlightColor: context.colors.textLight,
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          width: MediaQuery.of(context).size.width,
          height: 84,
        ),
      ),
    );
  }
}
