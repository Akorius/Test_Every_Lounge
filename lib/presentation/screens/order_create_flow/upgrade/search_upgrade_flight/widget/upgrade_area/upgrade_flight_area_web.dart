import 'package:everylounge/core/config.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_area/gradient_text.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_area/not_public_offer.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpgradeFlightAreaWeb extends StatelessWidget {
  const UpgradeFlightAreaWeb({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.only(top: 100),
          child: Image(
            image: AssetImage(currentBuild.bg),
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 21),
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: BackArrowButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(AppImages.alfaUpgradeLogo),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 21),
                if (!aClubBuild)
                  GradientText(text: currentBuild.cashBackText)
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      textAlign: TextAlign.center,
                      currentBuild.cashBackText,
                      style: context.textStyles
                          .h1(color: context.colors.textLight, ruble: true)
                          .copyWith(fontSize: MediaQuery.of(context).size.width < 480 ? 16 : null),
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (!aClubBuild)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
                child: Text(
                  "*не является публичной офертой, точные детали акции запрашивайте у банка",
                  style: context.textStyles
                      .textSmallRegular(color: Colors.white)
                      .copyWith(fontSize: MediaQuery.of(context).size.width < 480 ? 8 : null),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else
          NotPublicOffer(
            firstStyle: context.textStyles
                .textSmallRegular(color: Colors.white)
                .copyWith(fontSize: MediaQuery.of(context).size.width < 480 ? 8 : null),
            secondStyle: context.textStyles
                .textSmallRegular(color: Colors.white)
                .copyWith(fontSize: MediaQuery.of(context).size.width < 480 ? 8 : null)
                .copyWith(decoration: TextDecoration.underline),
          )
      ],
    );
  }
}
