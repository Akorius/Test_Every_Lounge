import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmenitiesListWidget extends StatelessWidget {
  const AmenitiesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoungeCubit, LoungeState>(
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
          child: GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              crossAxisSpacing: 7,
              childAspectRatio: 2.15,
            ),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              ...?state.lounge.amenities?.asMap().entries.map((e) => ProductItem(
                    productRu: state.lounge.amenitiesRus?[e.key] ?? "Платная услуга",
                    productEn: e.value,
                    isAmentity: true,
                  )),
              ...?state.lounge.features?.asMap().entries.map((e) => ProductItem(
                    productRu: state.lounge.featuresRus?[e.key] ?? "Бесплатная услуга",
                    productEn: e.value,
                    isAmentity: false,
                  )),
            ],
          ),
        );
      },
    );
  }
}
