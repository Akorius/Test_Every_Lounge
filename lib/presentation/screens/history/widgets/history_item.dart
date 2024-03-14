import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatelessWidget {
  final Order order;

  const HistoryItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        order.type == OrderType.upgrade ? AppRoutes.orderDetailsModal : AppRoutes.orderDetailsScreen,
        extra: order,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.colors.buttonPressedText,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: context.colors.avatarBackgroundColor,
              radius: 20,
              child: SvgPicture.asset(_getIcon(order.type)),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('HH:mm', 'ru_RU').format(order.createdAt),
                        style: AppTextStyles.textSmallRegular(
                          color: context.colors.textNormalGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 2,
                          width: 2,
                          decoration: BoxDecoration(color: context.colors.textNormalGrey, shape: BoxShape.circle),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          getAirportName(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.textSmallRegular(
                            color: context.colors.textNormalGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    order.type == OrderType.lounge
                        ? "Проход в бизнес-зал"
                        : order.type == OrderType.upgrade
                            ? "Повышение класса перелёта"
                            : order.premiumService?.serviceName() ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.regularButtonText(
                      color: context.colors.appBarBackArrowColor,
                    ),
                  ),
                  Text(
                    order.status.getDesignation(),
                    style: AppTextStyles.textSmallRegular(
                      color: order.status.getStatusColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (order.showPasses && order.type == OrderType.lounge)
              Text(
                TextUtils.passesText(order.passengers.length),
                style: context.textStyles.priceText(),
              )
            else
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    MoneyFormatter.getFormattedCost(order.amount),
                    style: context.textStyles.priceText(ruble: true),
                  ),
                  Text(
                    ' ₽',
                    style: context.textStyles.priceText(ruble: true),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  String getAirportName() {
    switch (order.type) {
      case OrderType.premium:
        return order.premiumService?.airport.name.isEmpty == true
            ? order.premiumService?.airport.city ?? ''
            : order.premiumService?.airport.name ?? '';
      case OrderType.upgrade:
        return order.aeroflotData?.legs?.first.segments.first.destination.airportName ?? '';
      case OrderType.lounge:
      default:
        return order.lounge.airport.name.isEmpty == true ? order.lounge.airport.city : order.lounge.airport.name;
    }
  }
}

String _getIcon(OrderType? type) {
  switch (type) {
    case OrderType.premium:
      return AppImages.flightPremium;
    case OrderType.upgrade:
      return AppImages.flightUpgradeDiamond;
    case OrderType.lounge:
    case OrderType.unknown:
    default:
      return AppImages.lounge;
  }
}
