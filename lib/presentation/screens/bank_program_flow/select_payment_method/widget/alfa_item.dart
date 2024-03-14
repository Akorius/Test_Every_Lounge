import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlfaItem extends StatelessWidget {
  const AlfaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.cardSmallCircleAlfaDuck,
          height: 40,
        ),
        const SizedBox(width: 12),
        Text(
          "А-Клуб",
          style: context.textStyles.textLargeRegular(),
        ),
      ],
    );
  }
}
