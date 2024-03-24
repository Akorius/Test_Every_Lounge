import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:everylounge/presentation/screens/history/cubit.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Refresher extends StatefulWidget {
  final Widget wchild;
  const Refresher({super.key, required this.wchild});

  @override
  State<Refresher> createState() => _RefresherState();
}

class _RefresherState extends State<Refresher> {
  final double _offsetToArmed = 85.0;
  double magnifier = 1;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () => context.read<HistoryCubit>().getOrderList(),
      offsetToArmed: _offsetToArmed,
      onStateChanged: (state) {
        if (state.didChange(from: IndicatorState.idle)) {
          magnifier = 1;
        }
        if (state.didChange(to: IndicatorState.finalizing)) {
          magnifier = 0.5;
        }
      },
      builder: (context, child, controller) {
        return AnimatedBuilder(
          animation: controller,
          child: child,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                if (!controller.side.isNone)
                  SizedBox(
                    height: _offsetToArmed * controller.value * magnifier,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: EveryAppLoader(),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0.0, _offsetToArmed * controller.value * magnifier),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: widget.wchild,
    );
  }
}
