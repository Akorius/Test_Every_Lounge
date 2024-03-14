import 'dart:developer';

import 'package:dio/dio.dart';

const _connectTimeoutMS = 60000;
const _receiveTimeoutMS = 60000;

class TinkoffApiClient {
  static const baseUrl = 'https://business.tinkoff.ru/';

  Dio create(String accessToken) {
    final Dio client = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeoutMS,
        receiveTimeout: _receiveTimeoutMS,
      ),
    );

    client.interceptors.addAll([
      InterceptorsWrapper(onRequest: (options, handler) async {
        options.headers['Authorization'] = 'Bearer ${accessToken}';
        return handler.next(options);
      }),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (m) => {log(m.toString())},
      ),
    ]);

    return client;
  }
}
