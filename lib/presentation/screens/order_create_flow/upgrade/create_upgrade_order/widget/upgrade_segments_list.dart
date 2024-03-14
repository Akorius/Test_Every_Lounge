import 'package:everylounge/domain/entities/upgrade_flight/leg.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/state.dart';
import 'package:flutter/material.dart';

import 'segment_item.dart';

class UpgradeSegmentsList extends StatelessWidget {
  const UpgradeSegmentsList({
    Key? key,
    required this.leg,
    required this.state,
  }) : super(key: key);

  final Leg leg;
  final CreateUpgradeOrderState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...leg.segments.map((segment) => segment.upgrades != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: SegmentItem(
                  segment: segment,
                  state: state,
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }
}
