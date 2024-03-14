import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BeelineKZItem extends StatelessWidget {
  const BeelineKZItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.beelineKZ,
          height: 40,
        ),
        const SizedBox(width: 12),
        Text(
          "Beeline Business Kazakhstan",
          style: context.textStyles.textLargeRegular(),
        ),
      ],
    );
  }
}
