import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required this.count,
    required this.onPressedMinus,
    required this.onPressedPlus,
    this.opacityPlus,
  });

  final int count;
  final Function() onPressedMinus;
  final Function? onPressedPlus;
  final double? opacityPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => count > 0 ? onPressedMinus.call() : null,
            child: SvgPicture.asset(
              AppImages.minus,
              color: context.colors.textDefault.withOpacity(count > 0 ? 1 : 0.2),
              width: 24,
              height: 24,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: context.textStyles.textLargeRegular(color: context.colors.textDefault),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => onPressedPlus?.call(),
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                AppImages.plus,
                color: context.colors.textDefault.withOpacity(opacityPlus ?? 1),
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
