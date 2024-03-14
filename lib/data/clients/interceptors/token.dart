import 'dart:async';

import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';

class TokenInterceptor extends Interceptor {
  final TokensStorage _tokensStorage = getIt();

  Future<RequestOptions> requestInterceptor(RequestOptions options, Dio client) async {
    if (noTokenPaths.any((element) => options.path.endsWith(element))) {
      return options;
    }
    if (_tokensStorage.accessToken != null) {
      options.data ??= {};
      options.headers['Authorization'] = 'Bearer ${_tokensStorage.accessToken}';
      return options;
    }

    return options;
  }
}

const List noTokenPaths = ["v1/auth/login"];
