import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/pay_by_card.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

class PassesArea extends StatelessWidget {
  final int passengersCount;
  final int passesLeftCount;
  final bool canPress;
  final bool canPayByPass;
  final bool loading;
  final bool isTinkoff;
  final Function() onUsePassPress;
  final Function() onPayWithCardPressed;

  const PassesArea({
    Key? key,
    required this.canPress,
    required this.canPayByPass,
    required this.loading,
    required this.passengersCount,
    required this.onUsePassPress,
    required this.onPayWithCardPressed,
    required this.passesLeftCount,
    this.isTinkoff = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonAreaDecoration(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: PlatformWrap.isWeb ? 24 : 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              passesLeftCount == -1
                  ? Flexible(
                      child: Text(
                      'Безлимитные проходы',
                      style: context.textStyles.textLargeBold(color: context.colors.textLoungeProduct),
                    ))
                  : Text(
                      "${TextUtils.availableText(passesLeftCount)} ${TextUtils.passesText(passesLeftCount)}",
                      style: context.textStyles.textLargeBold(),
                    ),
              const SizedBox(width: 10),
              Text(
                'Выбрано: $passengersCount',
                style: context.textStyles.textLargeRegular(color: context.colors.textLoungeProduct),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RegularButton(
            color: isTinkoff ? context.colors.textDefault : null,
            label: const Text("Оформить"),
            onPressed: onUsePassPress,
            canPress: canPress && canPayByPass,
            isLoading: loading,
          ),
          (!PlatformWrap.isWeb) ? PayByCard(onPayWithCardPressed: onPayWithCardPressed) : const SizedBox.shrink()
        ],
      ),
    );
  }
}
