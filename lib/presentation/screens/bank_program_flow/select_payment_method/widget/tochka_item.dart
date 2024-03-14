import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TochkaItem extends StatelessWidget {
  const TochkaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.tochka,
          height: 40,
        ),
        const SizedBox(width: 12),
        Text(
          "Бонусный счёт Точка",
          style: context.textStyles.textLargeRegular(),
        ),
      ],
    );
  }
}
