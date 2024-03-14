import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/product_item.dart';
import 'package:flutter/material.dart';

class AvailableServicesList extends StatelessWidget {
  final PremiumService service;

  const AvailableServicesList({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          crossAxisSpacing: 7,
          childAspectRatio: 2.15,
        ),
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          ...?service.amenities?.asMap().entries.map(
                (e) => ProductItem(
                  productRu: service.amenitiesRus?[e.key] ?? "Платная услуга",
                  productEn: e.value,
                  isAmentity: true,
                ),
              ),
          ...?service.features?.asMap().entries.map(
                (e) => ProductItem(
                  productRu: service.featuresRus?[e.key] ?? "Бесплатная услуга",
                  productEn: e.value,
                  isAmentity: false,
                ),
              ),
        ],
      ),
    );
  }
}
