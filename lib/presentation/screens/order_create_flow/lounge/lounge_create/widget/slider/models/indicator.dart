import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    required this.pageController,
    required this.ind,
    required this.isActive,
    required this.animationDuration,
    required this.animationCurve,
    required this.itemsCount,
    required this.indicatorShape,
    required this.selectedDotColor,
  }) : super(key: key);

  final PageController pageController;
  final int ind;
  final bool isActive;
  final Duration animationDuration;
  final Curve animationCurve;
  final int itemsCount;
  final BoxShape indicatorShape;
  final Color selectedDotColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pageController.animateToPage(ind, duration: animationDuration, curve: animationCurve);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 4,
        width: (MediaQuery.of(context).size.width - 60) / itemsCount,
        decoration: BoxDecoration(
          shape: indicatorShape,
          color: isActive ? selectedDotColor : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
