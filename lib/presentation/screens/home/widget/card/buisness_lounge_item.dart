import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessLoungeWidget extends StatelessWidget {
  const BusinessLoungeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.businessLounge),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Выбрать бизнес-зал",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.header700(color: context.colors.textLight),
                  ),
                  const SizedBox(height: 4),
                  AutoSizeText(
                    "Доступно более 1000 бизнес-залов по всему миру",
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    minFontSize: 6,
                    style: AppTextStyles.tinkoffIdButton(color: context.colors.iconUnselected),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.fromBorderSide(
                        BorderSide(color: context.colors.cardBackground.withOpacity(0.5)),
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppImages.arrowForward,
                    ),
                  )
                ],
              ),
            ),
          ),
          Image.asset(
            AppImages.loungeChair,
            height: 120,
            width: 120,
          ),
        ],
      ),
    );
  }
}
