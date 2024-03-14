abstract class RemoteConfigStorage {
  Future init();

  Future fetch();

  String get attachCardTinkoffTerminalKey;

  String get attachCardTinkoffSecret;

  String get clientTinkoffAllShopsPublicKey;

  String get prodForeignTinkoffTerminalKey;

  String get prodForeignTinkoffSecret;

  String get prodTinkoffTerminalKey;

  String get prodTinkoffSecret;

  String get qrOrganizationId;

  String get dragonPassOrganizationId;

  List<String> get airportOrgIds;

  String get sentryKey;

  String get tinkoffIdClientId;

  String get tinkoffIdClientIdWeb;

  String get tinkoffIdClientSecretWeb;

  String get tinkoffIdRedirectUri;

  String get tinkoffIdRedirectUriWeb;

  String get privacyPolicyUri;

  String get termsOfUsageUri;

  String get offerUri;

  bool get hideBanksIOSFaq;

  bool get hideBanksIOSDetailedActiveCard;

  ///tinkoffID
  bool get hideBanksTinkoffIdLoginWeb;

  bool get hideBanksTinkoffIdLoginIOS;

  bool get hideBanksTinkoffIdLoginAndroid;

  ///tinkoffPassage
  bool get hideTinkoffPassageWeb;

  bool get hideTinkoffPassageIOS;

  bool get hideTinkoffPassageAndroid;

  ///alfaID
  bool get hideBanksAlfaIdLoginWeb;

  bool get hideBanksAlfaIdLoginIOS;

  bool get hideBanksAlfaIdLoginAndroid;

  bool get hideBanksIOSProfile;

  bool get hideBanksIOSModalAddBankCard;

  bool get hideLoungesIOS;

  bool get hideMeetAndAssistIOS;

  bool get hideUpgradesIOS;

  bool get hideUpgradesForAlfaPremIOS;

  bool get hideLoungesAndroid;

  bool get hideMeetAndAssistAndroid;

  bool get hideUpgradesAndroid;

  bool get hideUpgradesForAlfaPremAndroid;

  bool get hideLoungesWeb;

  bool get hideMeetAndAssistWeb;

  bool get hideUpgradesWeb;

  bool get hideUpgradesForAlfaPremWeb;

  bool get hideTochkaIOS;

  bool get hideTochkaAndroid;

  bool get hideTochkaWeb;

  bool get hideAlfaPremiumIOS;

  bool get hideAlfaPremiumAndroid;

  bool get hideAlfaPremiumWeb;

  bool get hideBeelineKZIOS;

  bool get hideBeelineKZAndroid;

  bool get hideBeelineKZWeb;

  bool get needLoadQRForLoungeMe;
}
