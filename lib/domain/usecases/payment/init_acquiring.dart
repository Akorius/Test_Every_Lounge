import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';
import 'package:tinkoff_acquiring_native_flutter/tinkoff_acquiring_native_flutter.dart' as n;

abstract class InitAcquiringUseCase {
  Future<Result<TinkoffAcquiring>> init({
    required ClientShop shop,
    isDebugMode = false,
  });

  Future<Result> initNative({
    required ClientShop shop,
    isDebugMode = false,
  });
}

class InitAcquiringUseCaseImpl implements InitAcquiringUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();
  final n.TinkoffAcquiring _tinkoffAcquiringNative = getIt();

  @override
  Future<Result<TinkoffAcquiring>> init({
    required ClientShop shop,
    isDebugMode = false,
  }) async {
    ///Инициализируем выбранный магазин
    late final String terminalKey;
    late final String terminalSecret;
    switch (shop) {
      case ClientShop.tinkoffRu:
        terminalKey = _remoteConfigStorage.prodTinkoffTerminalKey;
        terminalSecret = _remoteConfigStorage.prodTinkoffSecret;
        break;
      case ClientShop.tinkoffForeign:
        terminalKey = _remoteConfigStorage.prodForeignTinkoffTerminalKey;
        terminalSecret = _remoteConfigStorage.prodForeignTinkoffSecret;
        break;
      case ClientShop.attachCard:
        terminalKey = _remoteConfigStorage.attachCardTinkoffTerminalKey;
        terminalSecret = _remoteConfigStorage.attachCardTinkoffSecret;
        break;
    }
    if (terminalKey.isEmpty || terminalSecret.isEmpty) {
      const message = "Не удалось проинициализировать эквайринг";
      Log.exception(
        Exception(message),
        null,
        "InitAcquiringUseCase",
      );
      return Result.failure(message);
    }
    final config = TinkoffAcquiringConfig.credential(
      terminalKey: terminalKey,
      password: terminalSecret,
      isDebugMode: isDebugMode,
    );
    return Result.success(TinkoffAcquiring(config));
  }

  @override
  Future<Result> initNative({
    required ClientShop shop,
    isDebugMode = false,
  }) async {
    ///Инициализируем выбранный магазин
    late final String terminalKey;
    late final String publicKey;
    switch (shop) {
      case ClientShop.tinkoffRu:
        terminalKey = _remoteConfigStorage.prodTinkoffTerminalKey;
        break;
      case ClientShop.tinkoffForeign:
        terminalKey = _remoteConfigStorage.prodForeignTinkoffTerminalKey;
        break;
      case ClientShop.attachCard:
        terminalKey = _remoteConfigStorage.attachCardTinkoffTerminalKey;
        break;
    }
    publicKey = _remoteConfigStorage.clientTinkoffAllShopsPublicKey;

    if (terminalKey.isEmpty || publicKey.isEmpty) {
      const message = "Не удалось проинициализировать эквайринг.";
      Log.exception(
        Exception(message),
        null,
        "InitAcquiringUseCase",
      );
      return Result.failure(message);
    }
    await _tinkoffAcquiringNative.init(terminalKey: terminalKey, publicKey: publicKey);
    return Result.success(AcquiringKeyData(terminalKey, publicKey));
  }
}

class AcquiringKeyData {
  final String terminalKey;
  final String publicKey;

  AcquiringKeyData(this.terminalKey, this.publicKey);
}
