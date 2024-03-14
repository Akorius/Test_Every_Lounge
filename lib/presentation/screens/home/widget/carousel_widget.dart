import 'package:carousel_slider/carousel_slider.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/home/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselWidget extends StatelessWidget {
  final List<Order> activeOrdersList;

  const CarouselWidget({super.key, required this.activeOrdersList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: activeOrdersList.map((i) {
            int index = activeOrdersList.indexOf(i);
            return ProductItemWidget(
              activeOrdersList[index],
            );
          }).toList(),
          options: CarouselOptions(
              height: 119,
              viewportFraction: 0.92,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlay: activeOrdersList.length <= 1 ? false : true,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              enableInfiniteScroll: activeOrdersList.length <= 1 ? false : true,
              initialPage: 0,
              scrollPhysics: activeOrdersList.length <= 1 ? const NeverScrollableScrollPhysics() : null,
              onPageChanged: (index, reason) {
                context.read<HomeCubit>().onProductsPageChanged(index);
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: activeOrdersList.map(
            (i) {
              int index = activeOrdersList.indexOf(i);
              return Container(
                width: context.read<HomeCubit>().state.orderIndex == index ? 12 : 6,
                height: 6,
                margin: const EdgeInsets.only(left: 2, right: 2, top: 8),
                decoration: BoxDecoration(
                    borderRadius: context.read<HomeCubit>().state.orderIndex == index ? BorderRadius.circular(10) : null,
                    shape: context.read<HomeCubit>().state.orderIndex == index ? BoxShape.rectangle : BoxShape.circle,
                    color: context.read<HomeCubit>().state.orderIndex == index
                        ? context.colors.activeIndicatorColor
                        : context.colors.disabledIndicatorColor),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
