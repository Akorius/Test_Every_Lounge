import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final Function onRefresh;
  final double offset = 85;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: offset,
      autoRebuild: false,
      onRefresh: () => onRefresh.call(),
      builder: (BuildContext context, Widget child, IndicatorController controller) {
        return AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                if (!controller.side.isNone)
                  Container(
                      height: offset * controller.value,
                      color: context.colors.backgroundColor,
                      width: double.infinity,
                      child: const Stack(
                        clipBehavior: Clip.hardEdge,
                        children: <Widget>[
                          Center(
                            child: OverflowBox(
                              maxHeight: 85,
                              minHeight: 85,
                              alignment: Alignment.center,
                              child: EveryAppLoader(),
                            ),
                          ),
                        ],
                      )),
                Transform.translate(
                  offset: Offset(0.0, offset * controller.value),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}
