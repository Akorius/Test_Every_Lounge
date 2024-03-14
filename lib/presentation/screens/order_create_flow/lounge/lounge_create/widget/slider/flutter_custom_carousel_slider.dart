import 'dart:async';

import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/models/carousel_item.model.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/models/indicator.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/models/indicator_position.dart';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider(
      {Key? key,
      required this.items,
      this.height = 200,
      this.subHeight,
      this.width = 400,
      this.autoplay = true,
      this.animationCurve = Curves.ease,
      this.autoplayDuration = const Duration(seconds: 3),
      this.animationDuration = const Duration(milliseconds: 300),
      this.indicatorShape = BoxShape.circle,
      this.dotSpacing = 5.0,
      this.selectedDotColor = Colors.white,
      this.selectedDotHeight = 8,
      this.selectedDotWidth = 8,
      this.unselectedDotColor = const Color(0XFFACAEBA),
      this.unselectedDotHeight = 6,
      this.unselectedDotWidth = 6,
      this.indicatorPosition = IndicatorPosition.insidePicture,
      this.showSubBackground = true,
      this.showText = true,
      this.boxPaddingHorizontal = 10,
      this.boxPaddingVertical = 2,
      this.onPageChanged})
      : super(key: key);

  /// [List<CarouselItem>] item list
  final List<CarouselItem> items;

  /// Height of container.Default is 200
  final double height;

  /// Height of sub container.Default is height * .4
  final double? subHeight;

  /// Width of container. Default is 400
  final double width;

  /// Position of indicators. Default is [IndicatorPosition.insidePicture]
  final IndicatorPosition indicatorPosition;

  /// Show title background(Box). Default true
  final bool showSubBackground;

  /// Show all text. Default true
  final bool showText;

  /// Auto play of the slider. Default true
  final bool autoplay;

  /// Transition page animation timing [Curve]. Default is [Curves.ease]
  final Curve animationCurve;

  /// [Duration] page animation duration. Default is 300ms.
  final Duration animationDuration;

  /// [Duration] of the Auto play slider. Default 3 seconds
  final Duration autoplayDuration;

  /// Shape of indicator. Default is [BoxShape.circle]
  final BoxShape indicatorShape;

  /// Horizontal margin between of each dot. Default is 5.0
  final double dotSpacing;

  /// [Color] of selected dot. Default is Color(0XFFACAEBA)
  final Color selectedDotColor;

  /// Height of selected dot. Default is 8
  final double selectedDotHeight;

  /// Width of selected dot. Default is 8
  final double selectedDotWidth;

  /// [Color] of unselected dot. Default is Color(0XFFACAEBA)
  final Color unselectedDotColor;

  /// Height of selected dot. Default is 6
  final double unselectedDotHeight;

  /// Width of selected dot. Default is 6
  final double unselectedDotWidth;

  /// [double] Box Padding Horizontal. Default is 10.0
  final double boxPaddingHorizontal;

  /// [double] Box Padding Vertical. Default is 2.0
  final double boxPaddingVertical;

  final Function(int)? onPageChanged;

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  Timer? timer;
  late PageController _pageController;
  int selectedIndex = 0;

  TextStyle subtitleTextstyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  TextStyle titleTextstyle = const TextStyle(
    color: Colors.white,
    fontSize: 13,
  );

  BoxDecoration boxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: FractionalOffset.bottomCenter,
      end: FractionalOffset.topCenter,
      colors: [
        Colors.black.withOpacity(1),
        Colors.black.withOpacity(.3),
      ],
      stops: const [0.0, 1.0],
    ),
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.autoplay) {
      timer = Timer.periodic(widget.autoplayDuration, (_) {
        if (_pageController.hasClients) {
          _goForward();
        }
      });
    }
    widget.onPageChanged?.call(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.items[selectedIndex].onImageTap != null) {
                  widget.items[selectedIndex].onImageTap!(selectedIndex);
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  _goForward();
                } else if (details.primaryVelocity! > 0) {
                  _goBack();
                }
              },
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext ctx, index) {
                      return widget.items[selectedIndex].image;
                    },
                    controller: _pageController,
                    itemCount: widget.items.length,
                    onPageChanged: (value) {
                      setState(() {
                        widget.onPageChanged?.call(value);
                        selectedIndex = value;
                      });
                    },
                  ),
                  widget.showSubBackground
                      ? Positioned(
                          bottom: 0,
                          height: widget.subHeight ?? widget.height * .4,
                          width: widget.width,
                          child: Container(
                            decoration: widget.items[selectedIndex].boxDecoration ?? boxDecoration,
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.boxPaddingHorizontal,
                              vertical: widget.boxPaddingVertical,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.items[selectedIndex].title ?? '',
                                    style: widget.items[selectedIndex].titleTextStyle ?? titleTextstyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  widget.indicatorPosition.showIndicator && widget.indicatorPosition.showIndicatorInside
                      ? Positioned.fill(
                          bottom: 30,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 60,
                              decoration: BoxDecoration(
                                color: widget.unselectedDotColor,
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.items
                                    .map(
                                      (i) => Indicator(
                                        pageController: _pageController,
                                        ind: widget.items.indexOf(i),
                                        isActive: widget.items.indexOf(i) == selectedIndex,
                                        animationDuration: widget.animationDuration,
                                        animationCurve: widget.animationCurve,
                                        indicatorShape: widget.indicatorShape,
                                        itemsCount: widget.items.length,
                                        selectedDotColor: widget.selectedDotColor,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  widget.showText
                      ? Positioned(
                          bottom: 5,
                          left: 10,
                          child: Text(
                            widget.items[selectedIndex].leftSubtitle ?? '',
                            style: widget.items[selectedIndex].leftSubtitleTextStyle ?? subtitleTextstyle,
                          ),
                        )
                      : Container(),
                  widget.showText
                      ? Positioned(
                          bottom: 5,
                          right: 10,
                          child: Text(
                            widget.items[selectedIndex].rightSubtitle ?? '',
                            style: widget.items[selectedIndex].rightSubtitleTextStyle ?? subtitleTextstyle,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goForward() {
    if (_pageController.page == widget.items.length - 1) {
      _pageController.animateToPage(0, duration: widget.animationDuration, curve: widget.animationCurve);
    } else {
      _pageController.nextPage(duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  void _goBack() {
    if (_pageController.page == 0.0) {
      _pageController.animateToPage(widget.items.length - 1, duration: widget.animationDuration, curve: widget.animationCurve);
    } else {
      _pageController.previousPage(duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }
}
