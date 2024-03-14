import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class ZeroSellBody extends StatelessWidget {
  const ZeroSellBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: Center(
            child: Image.asset(AppImages.historyZeroOrders),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Здесь будут отображаться ваши оформленные услуги',
              style: context.textStyles.h2(color: context.colors.buttonDisabled),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
