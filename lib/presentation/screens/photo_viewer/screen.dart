import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/core/utils/preloader.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/photo_viewer/cubit.dart';
import 'package:everylounge/presentation/screens/photo_viewer/state.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinity_page_view_astro/infinity_page_view_astro.dart';

class PhotoViewerScreen extends StatefulWidget {
  static const path = "photoViewer";

  const PhotoViewerScreen({Key? key}) : super(key: key);

  @override
  createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late InfinityPageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = InfinityPageController(initialPage: context.read<PhotoViewerCubit>().state.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoViewerCubit, PhotoViewerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.textDefault,
          appBar: AppAppBar(
            hideBackButton: true,
            onClosePressed: context.pop,
            verticalPadding: 4,
            rightPadding: 8,
            title: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: context.colors.textNormalGrey.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Text(
                "${state.currentPage + 1}/${state.idsList.length}",
                style: context.textStyles.textNormalRegular(color: context.colors.textLight),
              ),
            ),
          ),
          body: InfinityPageView(
              itemCount: state.idsList.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                var url = state.idsList[index];
                var id = url.substring(1);
                return CachedNetworkImage(
                    imageUrl: "${ApiClient.filesUrl}$id",
                    placeholder: (context, string) => const AppCircularProgressIndicator.large());
              },
              onPageChanged: (int index) {
                PreloaderImages.preloadImage(context, state.idsList, index);
                context.read<PhotoViewerCubit>().onPageChanged(index);
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
