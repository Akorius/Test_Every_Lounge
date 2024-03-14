import 'dart:typed_data';

import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;

abstract class ShareOrderUseCase {
  Future<Result<bool>> call(
    Widget widget,
    BuildContext context, {
    double? height = 2000,
    double? width,
    String? subject,
    String? text,
  });
}

class ShareOrderUseCaseImpl implements ShareOrderUseCase {
  final _controller = ScreenshotController();

  @override
  Future<Result<bool>> call(
    Widget widget,
    BuildContext context, {
    double? height = 2000,
    double? width,
    String? subject,
    String? text,
  }) async {
    try {
      final imageInBytes = await _controller.captureFromWidget(
        widget,
        context: context,
        targetSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? MediaQuery.of(context).size.height,
        ),
      );

      if (PlatformWrap.isWeb) {
        saveImg(imageInBytes, "order.png");
        return Result.success(true);
      }
      XFile.fromData(
        imageInBytes,
        mimeType: "image/png",
        lastModified: DateTime.now(),
      ).saveTo("${(await getTemporaryDirectory()).path}/1000.png");
    } catch (e, s) {
      Log.exception(e, s, "createScreenshot");
      return Result.failure("Не удалось создать изображение.");
    }

    try {
      await Share.shareXFiles(
        [XFile("${(await getTemporaryDirectory()).path}/1000.png")],
        subject: subject,
        text: text,
      );
    } catch (e, s) {
      Log.exception(e, s, "shareScreenshot");
      return Result.failure("Не удалось поделиться файлом.");
    }
    return Result.success(true);
  }
}

void saveImg(Uint8List bytes, String fileName) => js.context.callMethod("saveAs", [
      html.Blob([bytes]),
      fileName
    ]);
