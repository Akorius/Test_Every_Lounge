import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlfaPremItem extends StatelessWidget {
  const AlfaPremItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.cardSmallCircleAlfaPay,
          height: 32,
        ),
        const SizedBox(width: 12),
        Text(
          "",
          style: context.textStyles.textLargeRegular(),
        ),
      ],
    );
  }
}
