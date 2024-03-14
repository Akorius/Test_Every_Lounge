import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class PayByCard extends StatelessWidget {
  const PayByCard({
    super.key,
    required this.onPayWithCardPressed,
    this.canPress = true,
    this.text,
  });

  final Function? onPayWithCardPressed;
  final String? text;
  final bool? canPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            if (canPress == true) {
              final MetricsUseCase metricsUseCase = getIt<MetricsUseCase>();
              metricsUseCase.sendEvent(event: eventName[webViewPayButtonClick]!, type: MetricsEventType.click);

              onPayWithCardPressed?.call();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              text ?? "Оплатить банковской картой",
              style: context.textStyles.textNormalRegularGrey(),
            ),
          ),
        ),
      ),
    );
  }
}
