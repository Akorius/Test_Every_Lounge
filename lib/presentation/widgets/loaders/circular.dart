import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AppCircularProgressIndicator extends StatefulWidget {
  final Color? color;
  final double? size;
  final bool? isRevert;

  const AppCircularProgressIndicator({this.color, this.size, this.isRevert, Key? key}) : super(key: key);

  const AppCircularProgressIndicator.large({this.color, this.size = 48, this.isRevert, Key? key}) : super(key: key);

  @override
  State<AppCircularProgressIndicator> createState() => _AppCircularProgressIndicatorState();
}

class _AppCircularProgressIndicatorState extends State<AppCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController linearAnimationController;
  late final CurvedAnimation linearAnimation;
  var _animationValue = 0.0;

  @override
  void initState() {
    linearAnimationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    linearAnimation = CurvedAnimation(parent: linearAnimationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {
          _animationValue = linearAnimation.value * 360;
        });
      });
    linearAnimationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    linearAnimationController.stop();
    linearAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.size ?? 32,
        width: widget.size ?? 32,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              startAngle: _animationValue,
              endAngle: _animationValue + 350,
              radiusFactor: 1,
              axisLineStyle: AxisLineStyle(
                thickness: 0.27,
                cornerStyle: CornerStyle.bothFlat,
                color: context.colors.blueProgress,
                gradient: SweepGradient(
                  center: Alignment.bottomCenter,
                  colors: widget.isRevert == true
                      ? [context.colors.blueProgress.withOpacity(1), context.colors.textLight.withOpacity(0)]
                      : [context.colors.textLight.withOpacity(0), context.colors.blueProgress.withOpacity(1)],
                  stops: const [0, 1],
                ),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
