import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BankCardItem extends StatelessWidget {
  const BankCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppImages.otherBank,
          height: 40,
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Банковская карта",
              style: context.textStyles.textLargeRegular(),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImages.mir,
                AppImages.visa,
                AppImages.masterCard,
                AppImages.unionPay,
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: SvgPicture.asset(e),
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
