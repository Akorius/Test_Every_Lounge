import 'dart:convert';

import 'package:duration/duration.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigStorageImpl implements RemoteConfigStorage {
  final FirebaseRemoteConfig _remoteConfig = getIt();

  @override
  Future init() {
    return _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: seconds(60),
        minimumFetchInterval: minutes(60),
      ),
    );
  }

  @override
  Future fetch() => _remoteConfig.fetchAndActivate();

  @override
  String get attachCardTinkoffTerminalKey => _remoteConfig.getString(_Keys.attachCardTinkoffKey.name);

  @override
  String get attachCardTinkoffSecret => _remoteConfig.getString(_Keys.attachCardTinkoffPassword.name);

  @override
  String get clientTinkoffAllShopsPublicKey => _remoteConfig.getString(_Keys.clientTinkoffAllShopsPublicKey.name);

  @override
  String get prodForeignTinkoffTerminalKey => _remoteConfig.getString(_Keys.prodForeignTinkoffKey.name);

  @override
  String get prodForeignTinkoffSecret => _remoteConfig.getString(_Keys.prodForeignTinkoffPassword.name);

  @override
  String get prodTinkoffTerminalKey => _remoteConfig.getString(_Keys.prodTinkoffKey.name);

  @override
  String get prodTinkoffSecret => _remoteConfig.getString(_Keys.prodTinkoffPassword.name);

  @override
  String get qrOrganizationId => _remoteConfig.getString(_Keys.qrOrganizationId.name);

  @override
  String get dragonPassOrganizationId => _remoteConfig.getString(_Keys.dragonPassOrganizationId.name);

  @override
  List<String> get airportOrgIds {
    try {
      var jsonString = _remoteConfig.getString(_Keys.airOrganizationIds.name);
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.values.map((value) => value.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  String get sentryKey => _remoteConfig.getString(_Keys.sentryKey.name);

  @override
  String get tinkoffIdClientId => _remoteConfig.getString(_Keys.tinkoffIdIClientId.name);

  @override
  String get tinkoffIdClientIdWeb => _remoteConfig.getString(_Keys.tinkoffIdIClientIdWeb.name);

  @override
  String get tinkoffIdClientSecretWeb => _remoteConfig.getString(_Keys.tinkoffIdClientSecretWeb.name);

  @override
  String get tinkoffIdRedirectUri => _remoteConfig.getString(_Keys.tinkoffIdRedirectUri.name);

  @override
  String get tinkoffIdRedirectUriWeb => _remoteConfig.getString(_Keys.tinkoffIdRedirectUriWeb.name);

  @override
  String get privacyPolicyUri => _remoteConfig.getString(_Keys.privacyPolicyUri.name);

  @override
  String get termsOfUsageUri => _remoteConfig.getString(_Keys.termsOfUsageUri.name);

  @override
  String get offerUri => _remoteConfig.getString(_Keys.offerUri.name);

  @override
  bool get hideBanksIOSFaq => _remoteConfig.getBool(_HideParamKeys.hideBanksIOSFaq.name);

  @override
  bool get hideBanksIOSDetailedActiveCard => _remoteConfig.getBool(_HideParamKeys.hideBanksIOSDetailedActiveCard.name);

  @override
  bool get hideBanksTinkoffIdLoginWeb => _remoteConfig.getBool(_HideParamKeys.hideBanksTinkoffIdLoginWeb.name);

  @override
  bool get hideBanksTinkoffIdLoginIOS => _remoteConfig.getBool(_HideParamKeys.hideBanksTinkoffIdLoginIOS.name);

  @override
  bool get hideBanksTinkoffIdLoginAndroid => _remoteConfig.getBool(_HideParamKeys.hideBanksTinkoffIdLoginAndroid.name);

  @override
  bool get hideBanksAlfaIdLoginWeb => _remoteConfig.getBool(_HideParamKeys.hideBanksAlfaIdLoginWeb.name);

  @override
  bool get hideTinkoffPassageIOS => _remoteConfig.getBool(_HideParamKeys.hideTinkoffPassageIOS.name);

  @override
  bool get hideTinkoffPassageAndroid => _remoteConfig.getBool(_HideParamKeys.hideTinkoffPassageAndroid.name);

  @override
  bool get hideTinkoffPassageWeb => _remoteConfig.getBool(_HideParamKeys.hideTinkoffPassageWeb.name);

  @override
  bool get hideBanksAlfaIdLoginIOS => _remoteConfig.getBool(_HideParamKeys.hideBanksAlfaIdLoginIOS.name);

  @override
  bool get hideBanksAlfaIdLoginAndroid => _remoteConfig.getBool(_HideParamKeys.hideBanksAlfaIdLoginAndroid.name);

  @override
  bool get hideBanksIOSProfile => _remoteConfig.getBool(_HideParamKeys.hideBanksIOSProfile.name);

  @override
  bool get hideBanksIOSModalAddBankCard => _remoteConfig.getBool(_HideParamKeys.hideBanksIOSModalAddBankCard.name);

  @override
  bool get hideLoungesIOS => _remoteConfig.getBool(_ServiceSwitchers.hideLoungesIOS.name);

  @override
  bool get hideMeetAndAssistIOS => _remoteConfig.getBool(_ServiceSwitchers.hideMeetAndAssistIOS.name);

  @override
  bool get hideUpgradesIOS => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesIOS.name);

  @override
  bool get hideUpgradesForAlfaPremIOS => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesForAlfaPremIOS.name);

  @override
  bool get hideLoungesAndroid => _remoteConfig.getBool(_ServiceSwitchers.hideLoungesAndroid.name);

  @override
  bool get hideMeetAndAssistAndroid => _remoteConfig.getBool(_ServiceSwitchers.hideMeetAndAssistAndroid.name);

  @override
  bool get hideUpgradesAndroid => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesAndroid.name);

  @override
  bool get hideUpgradesForAlfaPremAndroid => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesForAlfaPremAndroid.name);

  @override
  bool get hideLoungesWeb => _remoteConfig.getBool(_ServiceSwitchers.hideLoungesWeb.name);

  @override
  bool get hideMeetAndAssistWeb => _remoteConfig.getBool(_ServiceSwitchers.hideMeetAndAssistWeb.name);

  @override
  bool get hideUpgradesWeb => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesWeb.name);

  @override
  bool get hideUpgradesForAlfaPremWeb => _remoteConfig.getBool(_ServiceSwitchers.hideUpgradesForAlfaPremWeb.name);

  @override
  bool get hideTochkaAndroid => _remoteConfig.getBool(_BankSwitchers.hideTochkaAndroid.name);

  @override
  bool get hideTochkaIOS => _remoteConfig.getBool(_BankSwitchers.hideTochkaIOS.name);

  @override
  bool get hideTochkaWeb => _remoteConfig.getBool(_BankSwitchers.hideTochkaWeb.name);

  @override
  bool get hideAlfaPremiumAndroid => _remoteConfig.getBool(_BankSwitchers.hideAlfaPremiumAndroid.name);

  @override
  bool get hideAlfaPremiumIOS => _remoteConfig.getBool(_BankSwitchers.hideAlfaPremiumIOS.name);

  @override
  bool get hideAlfaPremiumWeb => _remoteConfig.getBool(_BankSwitchers.hideAlfaPremiumWeb.name);

  @override
  bool get hideBeelineKZAndroid => _remoteConfig.getBool(_BankSwitchers.hideBeelineKZAndroid.name);

  @override
  bool get hideBeelineKZIOS => _remoteConfig.getBool(_BankSwitchers.hideBeelineKZIOS.name);

  @override
  bool get hideBeelineKZWeb => _remoteConfig.getBool(_BankSwitchers.hideBeelineKZWeb.name);

  @override
  bool get needLoadQRForLoungeMe => _remoteConfig.getBool(_Keys.needLoadQRForLoungeMe.name);
}

enum _Keys {
  attachCardTinkoffKey,
  attachCardTinkoffPassword,
  clientTinkoffAllShopsPublicKey,
  prodForeignTinkoffKey,
  prodForeignTinkoffPassword,
  prodTinkoffKey,
  prodTinkoffPassword,
  qrOrganizationId,
  dragonPassOrganizationId,
  airOrganizationIds,
  sentryKey,
  tinkoffIdIClientId,
  tinkoffIdIClientIdWeb,
  tinkoffIdClientSecretWeb,
  tinkoffIdRedirectUri,
  tinkoffIdRedirectUriWeb,
  privacyPolicyUri,
  termsOfUsageUri,
  offerUri,
  needLoadQRForLoungeMe
}

enum _HideParamKeys {
  hideBanksIOSFaq,
  hideBanksIOSDetailedActiveCard,

  ///login
  hideBanksTinkoffIdLoginWeb,
  hideBanksTinkoffIdLoginIOS,
  hideBanksTinkoffIdLoginAndroid,
  hideTinkoffPassageWeb,
  hideTinkoffPassageIOS,
  hideTinkoffPassageAndroid,
  hideBanksAlfaIdLoginWeb,
  hideBanksAlfaIdLoginIOS,
  hideBanksAlfaIdLoginAndroid,
  hideBanksIOSProfile,
  hideBanksIOSModalAddBankCard,
}

enum _BankSwitchers {
  hideTochkaIOS,
  hideTochkaAndroid,
  hideTochkaWeb,
  hideAlfaPremiumIOS,
  hideAlfaPremiumAndroid,
  hideAlfaPremiumWeb,
  hideBeelineKZIOS,
  hideBeelineKZAndroid,
  hideBeelineKZWeb,
}

enum _ServiceSwitchers {
  hideLoungesIOS,
  hideLoungesWeb,
  hideLoungesAndroid,
  hideMeetAndAssistIOS,
  hideMeetAndAssistWeb,
  hideMeetAndAssistAndroid,
  hideUpgradesAndroid,
  hideUpgradesIOS,
  hideUpgradesWeb,
  hideUpgradesForAlfaPremAndroid,
  hideUpgradesForAlfaPremIOS,
  hideUpgradesForAlfaPremWeb,
}
