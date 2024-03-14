import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'product_icon.dart';

class ProductItem extends StatelessWidget {
  final String productRu;
  final String productEn;
  final bool isAmentity;

  const ProductItem({
    required this.productRu,
    required this.productEn,
    Key? key,
    required this.isAmentity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 78,
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 14,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductIcon(product: productEn),
                if (isAmentity) SvgPicture.asset(AppImages.ruble, height: 20),
              ],
            ),
            const Spacer(),
            AutoSizeText(
              productRu,
              maxLines: 2,
              style: context.textStyles.textSmallRegular(color: context.colors.textLoungeProduct),
            )
          ],
        ),
      ),
    );
  }
}
