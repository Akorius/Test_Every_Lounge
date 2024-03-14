import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';

import 'payment_area_decoration.dart';

class CardLoadingArea extends StatelessWidget {
  const CardLoadingArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ButtonAreaDecoration(
      height: 100,
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
      child: Center(child: AppCircularProgressIndicator()),
    );
  }
}
