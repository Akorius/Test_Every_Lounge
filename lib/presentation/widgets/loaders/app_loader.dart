import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EveryAppLoader extends StatefulWidget {
  final Color? color;
  final double? size;
  final bool? forSplash;

  const EveryAppLoader({this.color, this.size, this.forSplash, Key? key}) : super(key: key);

  const EveryAppLoader.large({this.color, this.size = 48, this.forSplash, Key? key}) : super(key: key);

  @override
  State<EveryAppLoader> createState() => _EveryAppLoaderState();
}

class _EveryAppLoaderState extends State<EveryAppLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controllerSecond;
  late AnimationController _controllerThird;
  late AnimationController _controllerFull;
  late Animation<double> _opacityAnimation;
  late Animation<double> _opacityAnimationSecond;
  late Animation<double> _opacityAnimationThird;
  late Animation<double> _opacityAnimationFull;

  var tickerProvider = MyCustomTickerProvider();
  int duration = 500;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: duration),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controllerSecond = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: duration),
    );

    _opacityAnimationSecond = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerSecond,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _controllerThird = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: duration),
    );

    _opacityAnimationThird = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerThird,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _controllerFull = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: duration),
    );

    _opacityAnimationFull = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controllerFull,
        curve: const Interval(0, 1.0, curve: Curves.easeInOut),
      ),
    );
    startAnimation();

    super.initState();
  }

  void startAnimation() {
    _controller.forward().whenComplete(() {
      _controllerSecond.forward().whenComplete(() {
        _controllerThird.forward().whenComplete(() {
          _controllerFull.forward().whenComplete(() {
            Future.delayed(Duration(milliseconds: duration)).then((value) => {
                  _controller.value = 0,
                  _controllerSecond.value = 0,
                  _controllerThird.value = 0,
                  _controllerFull.value = 0,
                  startAnimation(),
                });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: widget.size ?? 32,
        width: widget.size ?? 32,
        alignment: Alignment.center,
        child: Stack(
          children: [
            SvgPicture.asset(
              "assets/images/loader/empty.svg",
              width: widget.size,
              height: widget.size,
              color: widget.forSplash == true ? context.colors.textLight : null,
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: SvgPicture.asset("assets/images/loader/first.svg", width: widget.size, height: widget.size),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controllerSecond,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimationSecond.value,
                  child: SvgPicture.asset("assets/images/loader/second.svg", width: widget.size, height: widget.size),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controllerThird,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimationThird.value,
                  child: SvgPicture.asset("assets/images/loader/third.svg", width: widget.size, height: widget.size),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controllerFull,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimationFull.value,
                  child: SvgPicture.asset("assets/images/loader/full.svg", width: widget.size, height: widget.size),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
