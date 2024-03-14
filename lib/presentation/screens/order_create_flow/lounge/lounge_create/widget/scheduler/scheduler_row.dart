import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SchedulerRow extends StatelessWidget {
  const SchedulerRow({
    super.key,
    this.day,
    this.validFrom,
    this.validTill,
    this.isTitle,
  });

  final String? day;
  final String? validFrom;
  final String? validTill;
  final bool? isTitle;

  @override
  Widget build(BuildContext context) {
    var width = isTitle == true ? 85.0 : 105.0;
    return Column(
      children: [
        if (isTitle == null || isTitle == false)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Container(
              decoration: DottedDecoration(
                shape: Shape.line,
                linePosition: LinePosition.bottom,
                color: context.colors.lightDashBorder,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: width,
              child: isTitle == true
                  ? SvgPicture.asset(AppImages.clockFull)
                  : Text(
                      day ?? '',
                      style: context.textStyles.textNormalRegular(),
                    ),
            ),
            Container(
              alignment: Alignment.center,
              width: width,
              child: Text(
                isTitle == true ? 'Утро' : validFrom ?? '',
                style: context.textStyles.textNormalRegular(),
              ),
            ),
            Container(
              alignment: isTitle == true ? Alignment.center : Alignment.centerRight,
              width: width,
              child: Text(
                isTitle == true ? 'Вечер' : validTill ?? '',
                style: context.textStyles.textNormalRegular(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
