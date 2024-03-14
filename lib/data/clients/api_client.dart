import 'dart:developer';

import 'package:debug_overlay/debug_overlay.dart';
import 'package:dio/dio.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/interceptors/unauth.dart';
import 'package:flutter/foundation.dart';

import 'interceptors/token.dart';

const _connectTimeoutMS = 60000;
const _receiveTimeoutMS = 60000;

class ApiClient {
  static const devHost = 'api.everylounge.staff.factory.codes';
  static const devApiUrl = 'https://$devHost/api/v1/';
  static const prodHost = 'rest.everylounge.app';
  static const prodApiUrl = 'https://$prodHost/api/v1/';
  static const baseUrl = production ? prodApiUrl : devApiUrl;
  static const filesUrl = "${baseUrl}files/";

  final TokenInterceptor _tokenInterceptor = getIt();
  final LogOutInterceptor _logOutInterceptor = getIt();

  Dio create() {
    final Dio client = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeoutMS,
        receiveTimeout: _receiveTimeoutMS,
      ),
    );

    var dlog = LogCollection();
    client.interceptors.addAll([
      InterceptorsWrapper(onRequest: (options, handler) async {
        final newOptions = await _tokenInterceptor.requestInterceptor(options, client);
        return handler.next(newOptions);
      }),
      if (!kReleaseMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (m) => {
            dlog.add(Log(
              message: m.toString(),
            )),
            if (!m.toString().contains("api/v1/metrics")) {log(m.toString())}
          },
        ),
      InterceptorsWrapper(onError: (error, handler) => _logOutInterceptor.onError(error, handler))
    ]);

    DebugOverlay.helpers.value = [LogsDebugHelper(dlog)];

    return client;
  }
}
