import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/platform.dart';

abstract class FindOutHideBanksUseCase {
  bool get hideTochkaBank;

  bool get hideBeelineKZBank;

  bool get hideAlfaPremium;
}

class FindOutHideBanksUseCaseImpl implements FindOutHideBanksUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();

  @override
  bool get hideTochkaBank {
    if (alfaBuild) return true;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideTochkaWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideTochkaIOS;
    } else {
      return _remoteConfigStorage.hideTochkaAndroid;
    }
  }

  @override
  bool get hideBeelineKZBank {
    if (alfaBuild) return true;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideBeelineKZWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideBeelineKZIOS;
    } else {
      return _remoteConfigStorage.hideBeelineKZAndroid;
    }
  }

  @override
  bool get hideAlfaPremium {
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideAlfaPremiumWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideAlfaPremiumIOS;
    } else {
      return _remoteConfigStorage.hideAlfaPremiumAndroid;
    }
  }
}
