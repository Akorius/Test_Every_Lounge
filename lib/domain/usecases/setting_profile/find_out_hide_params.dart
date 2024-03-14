import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/entities/common/platform.dart';

abstract class FindOutHideParamsUseCase {
  bool faq();

  bool detailedActiveCard();

  bool isHideTinkoffIdLogin();

  bool isHideTinkoffPassage();

  bool isHideAlfaIdLogin();

  bool isHideBanksIOS();

  bool modalAddBankCard();

  bool needLoadQRForLoungeMe();
}

class FindOutHideParamsUseCaseImplMock implements FindOutHideParamsUseCase {
  @override
  bool detailedActiveCard() {
    return true;
  }

  @override
  bool faq() {
    return true;
  }

  @override
  bool isHideAlfaIdLogin() {
    return true;
  }

  @override
  bool isHideBanksIOS() {
    return true;
  }

  @override
  bool isHideTinkoffIdLogin() {
    return true;
  }

  @override
  bool isHideTinkoffPassage() {
    return true;
  }

  @override
  bool modalAddBankCard() {
    return true;
  }

  @override
  bool needLoadQRForLoungeMe() {
    return false;
  }
}

class FindOutHideParamsUseCaseImpl implements FindOutHideParamsUseCase {
  final RemoteConfigStorage _remoteConfigStorage = getIt();

  @override
  bool faq() {
    return _remoteConfigStorage.hideBanksIOSFaq && PlatformWrap.isIOS;
  }

  @override
  bool detailedActiveCard() {
    return _remoteConfigStorage.hideBanksIOSDetailedActiveCard && PlatformWrap.isIOS;
  }

  @override
  bool needLoadQRForLoungeMe() {
    return _remoteConfigStorage.needLoadQRForLoungeMe;
  }

  @override
  bool isHideTinkoffIdLogin() {
    if (alfaBuild) return true;
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideBanksTinkoffIdLoginWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideBanksTinkoffIdLoginIOS;
    } else {
      return _remoteConfigStorage.hideBanksTinkoffIdLoginAndroid;
    }
  }

  @override
  bool isHideTinkoffPassage() {
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideTinkoffPassageWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideTinkoffPassageIOS;
    } else {
      return _remoteConfigStorage.hideTinkoffPassageAndroid;
    }
  }

  @override
  bool isHideAlfaIdLogin() {
    if (PlatformWrap.isWeb) {
      return _remoteConfigStorage.hideBanksAlfaIdLoginWeb;
    } else if (PlatformWrap.isIOS) {
      return _remoteConfigStorage.hideBanksAlfaIdLoginIOS;
    } else {
      return _remoteConfigStorage.hideBanksAlfaIdLoginAndroid;
    }
  }

  @override
  bool isHideBanksIOS() {
    return _remoteConfigStorage.hideBanksIOSProfile && PlatformWrap.isIOS;
  }

  @override
  bool modalAddBankCard() {
    return _remoteConfigStorage.hideBanksIOSModalAddBankCard && PlatformWrap.isIOS;
  }
}
