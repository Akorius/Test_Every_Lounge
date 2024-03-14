import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/widget/app_home_shimmer.dart';
import 'package:everylounge/presentation/screens/home/widget/carousel_widget.dart';
import 'package:flutter/material.dart';

class ActiveProductsListWidget extends StatelessWidget {
  final List<Order> activeOrdersList;
  final bool ordersLoading;

  const ActiveProductsListWidget({
    required this.activeOrdersList,
    required this.ordersLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text("Активные услуги", style: AppTextStyles.textLargeBold(color: context.colors.textBlue)),
        ),
        const SizedBox(height: 8),
        ordersLoading
            ? const AppHomeShimmer()
            : Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: activeOrdersList.isNotEmpty
                    ? CarouselWidget(activeOrdersList: activeOrdersList)
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 73,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colors.cardBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "У вас пока нет активных услуг",
                          style: AppTextStyles.textLargeRegular(color: context.colors.textNormalGrey),
                        ),
                      ),
              ),
      ],
    );
  }
}
