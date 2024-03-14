import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/widget/card/buisness_lounge_item.dart';
import 'package:everylounge/presentation/screens/home/widget/card/premium_services_item.dart';
import 'package:everylounge/presentation/screens/home/widget/card/upgrade_flight_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({
    super.key,
    required this.hideMeetAndAssist,
    required this.hideUpgrades,
    required this.hideLounge,
  });

  final bool hideMeetAndAssist;
  final bool hideUpgrades;
  final bool hideLounge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text("Наши услуги", style: AppTextStyles.textLargeBold(color: context.colors.textBlue)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!hideLounge)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: GestureDetector(
              onTap: () {
                context.push(AppRoutes.searchAirport, extra: ServiceSearchType.lounge);
              },
              child: const BusinessLoungeWidget(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Row(
            children: [
              if (!hideUpgrades)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.upgradeFlight);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: !hideMeetAndAssist ? 8 : 0),
                      child: UpgradeFlightWidget(isLarge: hideMeetAndAssist),
                    ),
                  ),
                ),
              if (!hideMeetAndAssist)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.searchAirport, extra: ServiceSearchType.premium);
                    },
                    child: PremiumServicesWidget(isLarge: hideUpgrades),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
