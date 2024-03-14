import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:flutter/material.dart';

class EmptyCardArea extends StatelessWidget {
  final ProfileState state;

  const EmptyCardArea({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (PlatformWrap.isWeb) return Container(decoration: BoxDecoration(color: context.colors.backgroundColor));
    return Container(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 46),
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppImages.cardBlue, height: 200),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 46),
              Text(
                "Пока у вас нет сохраненных способов оплаты",
                style: context.textStyles.h2(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Оплачивайте банковской картой онлайн во время оформления услуг",
                style: context.textStyles.textLargeRegular(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
