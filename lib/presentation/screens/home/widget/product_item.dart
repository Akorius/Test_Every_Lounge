import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProductItemWidget extends StatelessWidget {
  final Order order;

  const ProductItemWidget(
    this.order, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        return GestureDetector(
          onTap: () {
            switch (order.type) {
              case OrderType.upgrade:
                {
                  context.push(AppRoutes.orderDetailsModal, extra: order);
                  break;
                }
              case OrderType.premium:
              case OrderType.lounge:
              default:
                {
                  context.push(AppRoutes.orderDetailsScreen, extra: order);
                  break;
                }
            }
          },
          child: Container(
            height: 119,
            padding: const EdgeInsets.only(left: 16, right: 12, top: 12, bottom: 12),
            margin: const EdgeInsets.only(left: 4, right: 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: AutoSizeText(
                          getAirportName(),
                          style: context.textStyles.textSmallBold(color: context.colors.sliderUnselected),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 22,
                        child: AutoSizeText(
                          order.contacts.name.toUpperCase(),
                          style: context.textStyles.textLargeBold(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        height: 20,
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          getBodyText(order.type),
                          style: context.textStyles.textLargeRegular(),
                          maxLines: 1,
                          minFontSize: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 17,
                        child: Row(
                          children: [
                            AutoSizeText(
                              'Смотреть заказ',
                              style:
                                  context.textStyles.textSmallRegular(color: context.colors.textNormalLink).copyWith(height: 1),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            SvgPicture.asset(
                              AppImages.shevrom,
                              width: 16,
                              height: 16,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 95,
                  width: 95,
                  child: Image.asset(getOrderTypeImage(order.type)),
                ),
              ],
            ),
          ),
        );
      },
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

  String getBodyText(OrderType? type) {
    switch (type) {
      case OrderType.premium:
        return order.premiumService?.serviceName() ?? '';
      case OrderType.upgrade:
        var fNumber = order.aeroflotData?.legs?.first.segments.first.flightNumber;
        return 'Повышение класса: $fNumber';
      case OrderType.lounge:
      default:
        return order.lounge.name;
    }
  }

  String getOrderTypeImage(OrderType? type) {
    switch (type) {
      case OrderType.lounge:
        return AppImages.businessIcon;
      case OrderType.premium:
        return AppImages.vipIconProductCard;
      case OrderType.upgrade:
        return AppImages.updateIconProductCard;
      default:
        return AppImages.upgradeIconProduct;
    }
  }
}
