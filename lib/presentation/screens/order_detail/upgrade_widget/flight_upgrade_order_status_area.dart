import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FlightUpgradeOrderStatus extends StatelessWidget {
  final Order order;
  final bool isPremiumStatusAlfa;

  const FlightUpgradeOrderStatus({
    Key? key,
    required this.order,
    required this.isPremiumStatusAlfa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      height: 78,
      decoration: BoxDecoration(
        gradient: isPremiumStatusAlfa == true ? context.colors.alfaUpgradeStatusBackground : null,
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.status.getDesignationUpgrade(),
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.textLargeBold(
                        color: order.status.getStatusColorUpgrade(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd.MM.yyyy').format(order.createdAt),
                    style: context.textStyles.textNormalRegular(),
                  )
                ],
              ),
            ),
          ),
          if (order.status == OrderStatus.completed || order.status == OrderStatus.visited)
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.completeUpgradeInfoScreen);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 62,
                width: 64,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  color: Color(0xFFE3EBFA),
                ),
                child: SvgPicture.asset(AppImages.infoSquare),
              ),
            ),
        ],
      ),
    );
  }
}
