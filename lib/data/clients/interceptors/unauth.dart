import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_anon.dart';

class LogOutInterceptor extends Interceptor {
  final TokensStorage _tokensStorage = getIt();

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !noLogoutPaths.contains(err.requestOptions.uri.toString())) {
      _tokensStorage.accessToken = null;
      _tokensStorage.tinkoffRefreshToken = null;
      _tokensStorage.alfaRefreshToken = null;
      _tokensStorage.refreshToken = null;
      await getIt<SignInWithAnonUseCase>().signIn();
    }
    handler.next(err);
  }
}

const List noLogoutPaths = ["/metrics"];
