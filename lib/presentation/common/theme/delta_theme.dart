import 'package:flutter/material.dart';

import 'alfa_palette.dart';
import 'theme.dart';

class DeltaPalette {
  static const mainBlue1 = Color(0xFF143932);
  static const mainBlue2 = Color(0xFF164940);
  static const middleBlue1 = Color(0xFF3A6D66);
  static const middleBlue2 = Color(0xFF9EB1AD);
  static const middleBlue3 = Color(0xFF7A93C6);
  static const middleBlue4 = Color(0xFFEBEDFE);
  static const middleBlue5 = Color(0xFF062F81);
  static const lightBlue1 = Color(0xFFBAD2CE);
  static const lightBlue2 = Color(0xFFDDF0ED);
  static const lightBlue3 = Color(0xFFEDF3FC);
  static const lightGray = Color(0xFFF9FFF8);
  static const black = Color(0xFF1A1A1A);
  static const blackOpacity = Color.fromARGB(175, 0, 0, 0);
  static const grey1 = Color(0xFF8C8C8C);
  static const grey2 = Color(0xFFBABABA);
  static const grey3 = Color(0xFFE8E8E8);
  static const grey4 = Color(0xFFCFCFCF);
  static const grey5 = Color(0xFF929292);
  static const darkPurple = Color(0xFF0B3349);
  static const purple = Color(0xFF1C4C68);
  static const white = Color(0xFFFFFFFF);
  static const system = Color(0xFFFFC300);
  static const error = Color(0xFFE65037);
  static const red = Color(0xFFDC4433);
  static const shadow1 = Color.fromARGB(25, 153, 171, 198);
  static const shadow2 = Color.fromARGB(10, 153, 171, 198);
  static const tinkoffYellow = Color(0xFFF9DE56);
  static const green = Color(0xFF1BB863);
  static const yellow = Color(0xFFF4B30B);
  static const gazPromPremium = Color(0xFF562C33);
  static const gazPromPremiumBlack = Color(0xFF131011);
  static const otkrytie = Color(0xFF00BEF0);
  static const mkb = Color(0xFF1D1D1B);
  static const alfaGrey = Color(0x5B5B5B);
  static const transparent = Colors.transparent;
  static const activeIndicatorColor = Color(0xFF9EAEED);
  static const disabledIndicatorColor = Color(0xFFD8D9DC);

  static const updateFlightBackgroundColor = Color(0xFF312850);
  static const premiumServiceBackgroundColor = Color(0x143932);
  static const buisnessBackgoudColor = Color(0xFF021B4E);

  static const titleBackgroundAlfaColor = Color(0xFFEF3124);
  static const titleBackgroundGazpromColor = Color(0xFF562737);
  static const titleBackgroundMKBColor = Color(0xFFDD0A34);
  static const titleBackgroundOtkrityeColor = Color(0xFF3C3C3C);
  static const titleBackgroundTinkoffColor = Color(0xFFFFDD2E);
}

class DeltaAppTheme implements AppTheme {
  ///Button Regular
  @override
  final Color buttonEnabled = DeltaPalette.mainBlue2;
  @override
  final Color buttonEnabledText = DeltaPalette.white;
  @override
  final Color buttonPressed = DeltaPalette.mainBlue1;
  @override
  final Color buttonPressedText = DeltaPalette.white;
  @override
  final Color buttonDisabled = DeltaPalette.lightBlue1;
  @override
  final Color buttonDisabledText = DeltaPalette.white;
  @override
  final Color buttonEnabledGazProm = DeltaPalette.gazPromPremium;
  @override
  final Color buttonEnabledOtkrytie = DeltaPalette.otkrytie;
  @override
  final Color buttonEnabledMkb = DeltaPalette.mkb;
  @override
  final Color buttonBlack = DeltaPalette.black;
  @override
  final Color buttonNegative = DeltaPalette.white;
  @override
  final Color buttonNegativeText = DeltaPalette.mainBlue2;
  @override
  final Color buttonNegativePressed = DeltaPalette.grey3;
  @override
  final Color buttonNegativeDisabledText = DeltaPalette.lightBlue1;
  @override
  final Color buttonNegativeBorder = DeltaPalette.lightBlue1;

  ///Button in Login Info
  @override
  final Color buttonInfoBorder = DeltaPalette.white.withOpacity(0.3);
  @override
  final Color buttonInfoBorderBlue = DeltaPalette.middleBlue2;
  @override
  final Color searchBorder = DeltaPalette.lightBlue1;
  @override
  final Color buttonInfoText = DeltaPalette.middleBlue2;

  ///Tinkoff Button
  @override
  final Color buttonTinkoffBackground = DeltaPalette.tinkoffYellow;

  @override
  final Color buttonAlfaBackground = DeltaPalette.alfaGrey;

  ///Cards
  @override
  final Color cardBackground = DeltaPalette.white;
  @override
  final Color cardBackgroundGazPromPremium = DeltaPalette.gazPromPremiumBlack;
  @override
  final Color avatarBackgroundColor = DeltaPalette.mainBlue2;
  @override
  final Color searchBackground = DeltaPalette.white;
  @override
  final Color cardShadow = DeltaPalette.shadow1;
  @override
  final Color cardShadow2 = DeltaPalette.shadow2;
  @override
  final Color loginInfoCardText = DeltaPalette.lightBlue2;
  @override
  final Color cardSelectedBorder = DeltaPalette.middleBlue1;

  ///Фоны   ///Background
  @override
  final Color backgroundColor = DeltaPalette.lightGray;
  @override
  final Color switcherColor = DeltaPalette.lightBlue3;
  @override
  final Color tochkaWrapperBackground = DeltaPalette.lightBlue1;
  @override
  final Color dividerGray = DeltaPalette.grey3;
  @override
  final Color sliderSelected = DeltaPalette.grey3;
  @override
  final Color sliderUnselected = DeltaPalette.grey1;
  @override
  final Color backgroundAirportInfoBlock = DeltaPalette.middleBlue4;
  @override
  final Color bottomSheetBackgroundColor = DeltaPalette.white;
  @override
  final Color orderDetailsBackgroundColor = DeltaPalette.lightBlue2;
  @override
  final Color orderDetailsBackgroundTopColor = DeltaPalette.mainBlue1;
  @override
  final Color profileBackgroundColor = DeltaPalette.mainBlue1;
  @override
  final Color blackOpacity = DeltaPalette.blackOpacity;

  ///Appbars
  @override
  final Color appBarBackArrowColor = DeltaPalette.black;
  @override
  final Color appBarBackArrowBackground = DeltaPalette.white;
  @override
  final Color appBarText = DeltaPalette.white;
  @override
  final Color appBarBackArrowBorder = DeltaPalette.lightBlue2;
  @override
  final Color appBarTransparentBackgroundColor = DeltaPalette.transparent;

  ///Icons
  @override
  final Color iconUnselected = DeltaPalette.grey2;

  ///Background
  @override
  final Color dateText = DeltaPalette.grey2;
  @override
  final Color hintText = DeltaPalette.grey2;
  @override
  final Color iconSelected = DeltaPalette.middleBlue1;
  @override
  final Color searchIcon = DeltaPalette.mainBlue2;

  ///Текст
  @override
  final Color textNormalGrey = DeltaPalette.grey1;
  @override
  final Color textDefault = DeltaPalette.black;
  @override
  final Color textDate = DeltaPalette.grey2;
  @override
  final Color textLight = DeltaPalette.white;
  @override
  final Color textMiddleBlue = DeltaPalette.middleBlue5;
  @override
  final Color textProfileSetting = DeltaPalette.middleBlue3;
  @override
  final Color textOrderDetails = DeltaPalette.lightBlue1;
  @override
  final Color textOrderDetailsBlue = DeltaPalette.mainBlue2;
  @override
  final Color textOrderDetailsImpart = DeltaPalette.middleBlue1;
  @override
  final Color textOrderDetailsTitle = DeltaPalette.mainBlue1;
  @override
  final Color textNormalLink = DeltaPalette.middleBlue1;
  @override
  final Color textAddCard = DeltaPalette.middleBlue1;
  @override
  final Color textError = DeltaPalette.error;
  @override
  final Color textCard = DeltaPalette.grey1;
  @override
  final Color textAirportCity = DeltaPalette.grey5;
  @override
  final Color textHistoryDate = DeltaPalette.mainBlue1;
  @override
  final Color textLoungeProduct = DeltaPalette.mainBlue1;

  @override
  Color get textDarkPurple => DeltaPalette.darkPurple;

  ///Поля ввода
  @override
  final Color textFieldHint = DeltaPalette.grey2;
  @override
  final Color textFieldBorderEnabled = DeltaPalette.lightBlue1;
  @override
  final Color textFieldBorderFocused = DeltaPalette.middleBlue1;
  @override
  final Color textFieldError = DeltaPalette.error;
  @override
  final Color textBlue = DeltaPalette.mainBlue2;

  ///Over
  @override
  final Color dashBorder = DeltaPalette.middleBlue1;
  @override
  final Color lightDashBorder = DeltaPalette.lightBlue1;
  @override
  final Color profileAvatarBorder = DeltaPalette.mainBlue2;

  @override
  final Color modalTopElementColor = DeltaPalette.middleBlue1;

  ///Progress
  @override
  final Color lightProgress = DeltaPalette.lightGray;
  @override
  final Color darkProgress = DeltaPalette.mainBlue1;
  @override
  final Color blueProgress = DeltaPalette.mainBlue2;

  ///Orders Status
  @override
  final Color created = DeltaPalette.mainBlue2;
  @override
  final Color confirmed = DeltaPalette.green;
  @override
  final Color paid = DeltaPalette.green;
  @override
  final Color completed = DeltaPalette.middleBlue2;
  @override
  final Color cancelled = DeltaPalette.grey1;
  @override
  final Color initPay = DeltaPalette.mainBlue2;
  @override
  final Color bankPaid = DeltaPalette.yellow;
  @override
  final Color visited = DeltaPalette.yellow;
  @override
  final Color expired = DeltaPalette.grey1;
  @override
  final Color defaultStatus = DeltaPalette.yellow;

  @override
  Color get buttonEnableRed => DeltaPalette.red;

  @override
  Color get flightOrderBackgroundColor => DeltaPalette.darkPurple;

  @override
  Color get flightTiketRedBackgroundColor => DeltaPalette.red;

  @override
  Color get searchAirportWarningBackground => DeltaPalette.lightBlue1;

  @override
  Color get textGreen => DeltaPalette.green;

  ///Upgrade alfa
  @override
  final Color upgradePaidStatus = AlfaPalette.alfaUpgradeGrey;
  @override
  final Color upgradeCompleteStatus = AlfaPalette.alfaUpgradeGreen;
  @override
  final Color upgradeCancelledStatus = DeltaPalette.error;
  @override
  final LinearGradient alfaUpgradeStatusBackground = AlfaPalette.upgradeLinearGradient;
  @override
  final LinearGradient upgradeAeroCompanyButtonBackground = AlfaPalette.upgradeLinearGradient;
  @override
  final Color buttonEnabledAlfa = AlfaPalette.alfaUpgradeBlack;
  @override
  final Color buttonDisabledAlfa = AlfaPalette.alfaUpgradeBlack30;

  @override
  Color get activeIndicatorColor => DeltaPalette.activeIndicatorColor;

  @override
  Color get disabledIndicatorColor => DeltaPalette.disabledIndicatorColor;

  @override
  Color get titleBackgroundAlfa => DeltaPalette.titleBackgroundAlfaColor;

  @override
  Color get titleBackgroundGazprom => DeltaPalette.titleBackgroundGazpromColor;

  @override
  Color get titleBackgroundMKB => DeltaPalette.titleBackgroundMKBColor;

  @override
  Color get titleBackgroundOtkritye => DeltaPalette.titleBackgroundOtkrityeColor;

  @override
  Color get titleBackgroundTinkoff => DeltaPalette.titleBackgroundTinkoffColor;
}
