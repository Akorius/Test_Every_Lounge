import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/core/utils/preloader.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/presentation/common/router/extra.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/flutter_custom_carousel_slider.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/models/carousel_item.model.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/slider/models/indicator_position.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/appbars/expand_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliverAppBar extends StatelessWidget {
  final List<String> gallery;
  final String name;
  final Function(double) callback;

  const CustomSliverAppBar(
    this.gallery,
    this.name,
    this.callback, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AppBarWidgetDelegate(gallery, name, callback),
    );
  }
}

class _AppBarWidgetDelegate extends SliverPersistentHeaderDelegate {
  _AppBarWidgetDelegate(
    this.gallery,
    this.name,
    this.callback,
  );

  final List<String> gallery;
  final String name;
  String? currentId;
  final Function(double) callback;

  final expandedHeight = 236.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    callback.call(getOpacity(shrinkOffset, false));
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: getOpacity(shrinkOffset, false),
          duration: duration,
          child: SizedBox(
            height: expandedHeight,
            width: double.infinity,
            child: CustomCarouselSlider(
              items: gallery.map((string) {
                var id = string.substring(1);
                return CarouselItem(
                  image: GestureDetector(
                    onTap: () => openViewer(context),
                    child: CachedNetworkImage(
                      imageUrl: "${ApiClient.filesUrl}$id",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      placeholder: (context, string) => Shimmer.fromColors(
                        baseColor: context.colors.backgroundColor,
                        highlightColor: context.colors.dividerGray,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              height: 150,
              subHeight: 50,
              width: MediaQuery.of(context).size.width * .9,
              autoplay: false,
              showText: false,
              showSubBackground: false,
              indicatorShape: BoxShape.rectangle,
              indicatorPosition: IndicatorPosition.insidePicture,
              unselectedDotColor: context.colors.sliderUnselected.withOpacity(0.2),
              onPageChanged: (index) => {
                PreloaderImages.preloadImage(context, gallery, index),
                currentId = gallery[index],
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.colors.backgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: AnimatedOpacity(
              opacity: getOpacity(shrinkOffset, false),
              duration: duration,
              child: const SizedBox(
                height: 16,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: AnimatedOpacity(
            opacity: shrinkOffset < 130 ? 0 : 1,
            duration: duration,
            child: Container(
              color: context.colors.backgroundColor,
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: getOpacity(shrinkOffset, true),
                      duration: duration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: AutoSizeText(
                          name,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: context.textStyles.textLargeBold(color: context.colors.textBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          top: 4,
          left: 8,
          child: BackArrowButton(),
        ),
        Positioned(
          top: 4,
          right: 8,
          child: ExpanderButton(
            onPressed: () => openViewer(context),
          ),
        ),
      ],
    );
  }

  void openViewer(BuildContext context) {
    context.push(AppRoutes.photoViewer, extra: {AppExtra.photoIdsList: gallery, AppExtra.currentId: currentId});
  }

  Duration duration = const Duration(milliseconds: 200);

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

  double getOpacity(double shrinkOffset, bool isAppBar) {
    var opacityMainTitle = 0.65 - shrinkOffset / expandedHeight;
    if (shrinkOffset == 0) {
      return isAppBar ? 0 : 1;
    } else {
      if (isAppBar) {
        return shrinkOffset < 130 ? 0 : shrinkOffset / expandedHeight;
      } else {
        return opacityMainTitle < 0 ? 0 : opacityMainTitle;
      }
    }
  }
}
