import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:everylounge/core/app.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/core/services_initializer.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_anon.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_old_token.dart';
import 'package:everylounge/domain/usecases/user/update_tinkoff_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  rateMyApp.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));

  ///android <7 certificate fix
  if (PlatformWrap.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt <= 25) {
      ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
      SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
    }
  }
  setUrlStrategy(PathUrlStrategy());

  await SentryFlutter.init(
    (options) => options
      ..beforeSend = beforeSend
      ..attachStacktrace = true
      ..dsn = PlatformWrap.isWeb ? "" : "https://c3d643bcf9624dc1b9ebb718986e33b2@sentry.staff.fabrika.codes/3"
      ..diagnosticLevel = SentryLevel.debug
      ..debug = false,
    appRunner: () async {
      await registerGetIt();
      await initAsyncServices();
      if (PlatformWrap.isWeb) {
        getIt<SignInWithOldTokenUseCase>().signIn().then((result) {
          if (!result.isSuccess) {
            Log.message(result.message, sender: "Main", skipInProduction: true);
          }
          return getIt<SignInWithAnonUseCase>().signIn();
        }).then((result) {
          if (!result.isSuccess) {
            Log.message(result.message, sender: "Main", skipInProduction: true);
          }
          return getIt<UpdateTinkoffUserUseCase>().update();
        }).then((result) {
          if (!result.isSuccess) {
            Log.message(result.message, sender: "Main", skipInProduction: true);
          }
        }).catchError((e, s) {
          Log.exception(e, s, "Main");
        });
      }

      FlavorConfig(
        name: production ? "" : "DEV",
        color: const Color(0xFF062F81).withOpacity(0.9),
        location: BannerLocation.topStart,
      );

      runApp(const EveryLoungeApp());
    },
  );
}

FutureOr<SentryEvent?> beforeSend(SentryEvent event, {Hint? hint}) async {
  if (event.throwable is DioError) {
    var error = event.throwable as DioError;
    event = event.copyWith(fingerprint: ["${error.response?.statusCode} + ${error.requestOptions.path}"]);
  }
  return event;
}
