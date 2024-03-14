import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:flutter/material.dart';

class PreloaderImages {
  static void preloadImage(BuildContext context, List<String> idsList, int index) {
    if (index < idsList.length - 1) {
      var imageUrl = "${ApiClient.filesUrl}${(idsList[index + 1]).substring(1)}";
      precacheImage(CachedNetworkImageProvider(imageUrl), context);
    }
  }
}
