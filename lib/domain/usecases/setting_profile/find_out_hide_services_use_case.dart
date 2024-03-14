import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/platform.dart';

abstract class FindOutHideServicesUseCase {
  bool get hideLounge;

  bool get hideMeetAndAssist;

  bool get hideUpgrades;

  bool get hideUpgradesForAlfaPrem;
}

class FindOutHideServicesUseCaseImpl implements FindOutHideServicesUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();

  @override
  bool get hideLounge {
    if (alfaBuild) return true;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideLoungesWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideLoungesIOS;
    } else {
      return _remoteConfigStorage.hideLoungesAndroid;
    }
  }

  @override
  bool get hideMeetAndAssist {
    if (alfaBuild) return true;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideMeetAndAssistWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideMeetAndAssistIOS;
    } else {
      return _remoteConfigStorage.hideMeetAndAssistAndroid;
    }
  }

  @override
  bool get hideUpgrades {
    if (alfaBuild) return false;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideUpgradesWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideUpgradesIOS;
    } else {
      return _remoteConfigStorage.hideUpgradesAndroid;
    }
  }

  @override
  bool get hideUpgradesForAlfaPrem {
    if (alfaBuild) return false;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideUpgradesForAlfaPremWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideUpgradesForAlfaPremIOS;
    } else {
      return _remoteConfigStorage.hideUpgradesForAlfaPremAndroid;
    }
  }
}
