import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_area/not_public_offer.dart';
import 'package:flutter/material.dart';

class UpgradeFlightAreaAlfa extends StatelessWidget {
  const UpgradeFlightAreaAlfa({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 382,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.alfaUpgradeClubBg),
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "Повышайте класс перелёта\nс кэшбэком до 30 000 ₽\nот А-Клуба*",
                style: context.textStyles.h1(color: context.colors.textLight, ruble: true).copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const NotPublicOffer()
          ],
        ),
      ),
    );
  }
}
