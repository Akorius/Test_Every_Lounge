import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumServicesWidget extends StatelessWidget {
  const PremiumServicesWidget({
    super.key,
    required this.isLarge,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return isLarge
        ? Container(
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24),
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.premiumsServices),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Выбрать\nVIP-зал или\nMeet&Assist",
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        style: AppTextStyles.header700(color: context.colors.textLight),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.fromBorderSide(
                              BorderSide(color: context.colors.cardBackground.withOpacity(0.5)),
                            )),
                        child: SvgPicture.asset(
                          AppImages.arrowForward,
                        ),
                      )
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.only(left: 16, top: 16),
            height: MediaQuery.of(context).size.height / 4.9,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.vipBg),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: AutoSizeText(
                        "Выбрать VIP-зал\nили Meet&Assist",
                        maxLines: 2,
                        style: AppTextStyles.textLargeBold(color: context.colors.textLight),
                      ),
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
                Positioned(
                  bottom: -20,
                  right: -32,
                  child: Image.asset(
                    AppImages.vipIcon,
                    width: 139,
                    height: 139,
                  ),
                )
              ],
            ),
          );
  }
}
