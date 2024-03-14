import 'package:everylounge/presentation/screens/order_detail/premium_widget/order_status_area_premium_services.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:flutter/material.dart';

class PaidContentPremiumServices extends StatelessWidget {
  final OrderDetailsState state;

  const PaidContentPremiumServices({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 16),
      child: BottomOrderStatusAreaPremiumServices(state: state),
    );
  }
}
