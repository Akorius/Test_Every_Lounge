import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

abstract class InitTinkoffSDKUseCase {
  /// Инициализируем Tinkoff ID
  Future<Result> init();
}

class InitTinkoffSDKUseCaseImpl implements InitTinkoffSDKUseCase {
  final RemoteConfigStorage _remoteStorage = getIt();
  final TinkoffIdFlutter _tinkoffIdFlutter = getIt();

  @override
  Future<Result> init() async {
    /// Инициализируем Tinkoff ID
    final redirectUri = _remoteStorage.tinkoffIdRedirectUri;
    final clientId = _remoteStorage.tinkoffIdClientId;
    if (redirectUri.isEmpty || clientId.isEmpty) {
      final message = "redirectUri: $redirectUri, clientId: $clientId. Строка пустая.";
      Log.exception(Exception(message));
      return Result.failure(message);
    }
    await _tinkoffIdFlutter.init(clientId, redirectUri, false);
    return Result.success("");
  }
}
