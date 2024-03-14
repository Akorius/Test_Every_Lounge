import 'package:flutter/material.dart';

import 'alfa_palette.dart';
import 'theme.dart';

///Цвета основной темы
class MainPalette {
  static const mainBlue1 = Color(0xFF021B4E);
  static const transparent = Colors.transparent;
  static const mainBlue2 = Color(0xFF062F81);
  static const middleBlue1 = Color(0xFF586EBB);
  static const middleBlue2 = Color(0xFF9EAEED);
  static const middleBlue3 = Color(0xFF7A93C6);
  static const middleBlue4 = Color(0xFFEBEDFE);
  static const middleBlue5 = Color(0xFF062F81);
  static const lightBlue1 = Color(0xFFDFE1F7);
  static const lightBlue2 = Color(0xFFF6F6FD);
  static const lightBlue3 = Color(0xFFEDF3FC);
  static const lightGray = Color(0xFFF8FAFF);
  static const black = Color(0xFF1A1A1A);
  static const blackOpacity = Color.fromARGB(175, 0, 0, 0);
  static const grey1 = Color(0xFF8C8C8C);
  static const grey2 = Color(0xFFBABABA);
  static const grey3 = Color(0xFFE8E8E8);
  static const grey4 = Color(0xFFCFCFCF);
  static const grey5 = Color(0xFF929292);
  static const darkPurple = Color(0xFF312850);
  static const purple = Color(0xFF796DAA);
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

  static const activeIndicatorColor = Color(0xFF9EAEED);
  static const disabledIndicatorColor = Color(0xFFD8D9DC);

  static const updateFlightBackgroundColor = Color(0xFF312850);
  static const premiumServiceBackgroundColor = Color(0xFF143932);
  static const buisnessBackgoudColor = Color(0xFF021B4E);

  static const titleBackgroundAlfaColor = Color(0xFFEF3124);
  static const titleBackgroundGazpromColor = Color(0xFF562737);
  static const titleBackgroundMKBColor = Color(0xFFDD0A34);
  static const titleBackgroundOtkrityeColor = Color(0xFF3C3C3C);
  static const titleBackgroundTinkoffColor = Color(0xFFFFDD2E);
}

class MainAppTheme implements AppTheme {
  ///Button Regular
  @override
  final Color buttonEnabled = MainPalette.mainBlue2;
  @override
  final Color buttonEnableRed = MainPalette.red;
  @override
  final Color buttonEnabledText = MainPalette.white;
  @override
  final Color buttonPressed = MainPalette.mainBlue1;
  @override
  final Color buttonPressedText = MainPalette.white;
  @override
  final Color buttonDisabled = MainPalette.lightBlue1;
  @override
  final Color buttonDisabledText = MainPalette.white;

  @override
  final Color buttonEnabledGazProm = MainPalette.gazPromPremium;
  @override
  final Color buttonEnabledOtkrytie = MainPalette.otkrytie;
  @override
  final Color buttonEnabledMkb = MainPalette.mkb;

  @override
  final Color buttonNegative = MainPalette.white;
  @override
  final Color buttonBlack = MainPalette.black;
  @override
  final Color buttonNegativeText = MainPalette.mainBlue2;
  @override
  final Color buttonNegativePressed = MainPalette.grey3;
  @override
  final Color buttonNegativeDisabledText = MainPalette.lightBlue1;
  @override
  final Color buttonNegativeBorder = MainPalette.lightBlue1;

  ///Button in Login Info
  @override
  final Color buttonInfoBorder = MainPalette.white.withOpacity(0.3);
  @override
  final Color buttonInfoBorderBlue = MainPalette.middleBlue2;
  @override
  final Color searchBorder = MainPalette.lightBlue1;
  @override
  final Color buttonInfoText = MainPalette.middleBlue2;

  ///Tinkoff Button
  @override
  final Color buttonTinkoffBackground = MainPalette.tinkoffYellow;

  ///Cards
  @override
  final Color cardBackground = MainPalette.white;
  @override
  final Color cardBackgroundGazPromPremium = MainPalette.gazPromPremiumBlack;
  @override
  final Color avatarBackgroundColor = MainPalette.mainBlue2;
  @override
  final Color searchBackground = MainPalette.white;
  @override
  final Color cardShadow = MainPalette.shadow1;
  @override
  final Color cardShadow2 = MainPalette.shadow2;
  @override
  final Color loginInfoCardText = MainPalette.lightBlue2;
  @override
  final Color cardSelectedBorder = MainPalette.middleBlue1;

  ///Фоны   ///Background
  @override
  final Color switcherColor = MainPalette.lightBlue3;
  @override
  final Color backgroundColor = MainPalette.lightGray;
  @override
  final Color tochkaWrapperBackground = MainPalette.lightBlue1;
  @override
  final Color searchAirportWarningBackground = MainPalette.lightBlue1;
  @override
  final Color backgroundAirportInfoBlock = MainPalette.middleBlue4;
  @override
  final Color dividerGray = MainPalette.grey3;
  @override
  final Color sliderSelected = MainPalette.grey3;
  @override
  final Color sliderUnselected = MainPalette.grey1;

  @override
  final Color bottomSheetBackgroundColor = MainPalette.white;
  @override
  final Color orderDetailsBackgroundColor = MainPalette.lightBlue2;
  @override
  final Color orderDetailsBackgroundTopColor = MainPalette.mainBlue1;
  @override
  final Color profileBackgroundColor = MainPalette.mainBlue1;

  @override
  final Color flightTiketRedBackgroundColor = MainPalette.red;

  @override
  final Color flightOrderBackgroundColor = MainPalette.darkPurple;

  ///Appbars
  @override
  final Color appBarBackArrowColor = MainPalette.black;
  @override
  final Color appBarBackArrowBackground = MainPalette.white;
  @override
  final Color appBarText = MainPalette.white;
  @override
  final Color appBarBackArrowBorder = MainPalette.lightBlue2;
  @override
  final Color appBarTransparentBackgroundColor = MainPalette.transparent;

  ///Icons
  @override
  final Color iconUnselected = MainPalette.grey2;

  ///Background
  @override
  final Color dateText = MainPalette.grey2;
  @override
  final Color hintText = MainPalette.grey2;
  @override
  final Color iconSelected = MainPalette.middleBlue1;
  @override
  final Color searchIcon = MainPalette.mainBlue2;
  @override
  final Color blackOpacity = MainPalette.blackOpacity;

  ///Текст
  @override
  final Color textNormalGrey = MainPalette.grey1;
  @override
  final Color textGreen = MainPalette.green;
  @override
  final Color textDefault = MainPalette.black;
  @override
  final Color textDate = MainPalette.grey2;
  @override
  final Color textLight = MainPalette.white;
  @override
  final Color textProfileSetting = MainPalette.middleBlue3;
  @override
  final Color textOrderDetails = MainPalette.lightBlue1;
  @override
  final Color textOrderDetailsBlue = MainPalette.mainBlue2;
  @override
  final Color textOrderDetailsImpart = MainPalette.middleBlue1;
  @override
  final Color textOrderDetailsTitle = MainPalette.mainBlue1;
  @override
  final Color textNormalLink = MainPalette.middleBlue1;
  @override
  final Color textAddCard = MainPalette.middleBlue1;
  @override
  final Color textError = MainPalette.error;
  @override
  final Color textCard = MainPalette.grey1;
  @override
  final Color textMiddleBlue = MainPalette.middleBlue5;
  @override
  final Color textAirportCity = MainPalette.grey5;
  @override
  final Color textHistoryDate = MainPalette.mainBlue1;
  @override
  final Color textLoungeProduct = MainPalette.mainBlue1;
  @override
  final Color textDarkPurple = MainPalette.darkPurple;

  ///Поля ввода
  @override
  final Color textFieldHint = MainPalette.grey2;
  @override
  final Color textFieldBorderEnabled = MainPalette.lightBlue1;
  @override
  final Color textFieldBorderFocused = MainPalette.middleBlue1;
  @override
  final Color textFieldError = MainPalette.error;
  @override
  final Color textBlue = MainPalette.mainBlue2;

  ///Over
  @override
  final Color dashBorder = MainPalette.middleBlue1;
  @override
  final Color lightDashBorder = MainPalette.lightBlue1;
  @override
  final Color profileAvatarBorder = MainPalette.mainBlue2;

  @override
  final Color modalTopElementColor = MainPalette.middleBlue1;

  ///Progress
  @override
  final Color lightProgress = MainPalette.lightGray;

  @override
  final Color darkProgress = MainPalette.mainBlue1;

  @override
  final Color blueProgress = MainPalette.mainBlue2;

  ///Orders Status
  @override
  final Color created = MainPalette.mainBlue2;
  @override
  final Color confirmed = MainPalette.green;
  @override
  final Color paid = MainPalette.green;
  @override
  final Color completed = MainPalette.middleBlue2;
  @override
  final Color cancelled = MainPalette.grey1;
  @override
  final Color initPay = MainPalette.mainBlue2;
  @override
  final Color bankPaid = MainPalette.yellow;
  @override
  final Color visited = MainPalette.yellow;
  @override
  final Color expired = MainPalette.grey1;
  @override
  final Color defaultStatus = MainPalette.yellow;

  ///Upgrade alfa
  @override
  final Color upgradePaidStatus = AlfaPalette.alfaUpgradeGrey;
  @override
  final Color upgradeCompleteStatus = AlfaPalette.alfaUpgradeGreen;
  @override
  final Color upgradeCancelledStatus = MainPalette.error;
  @override
  final LinearGradient alfaUpgradeStatusBackground = AlfaPalette.upgradeLinearGradient;
  @override
  final LinearGradient upgradeAeroCompanyButtonBackground = AlfaPalette.upgradeLinearGradient;
  @override
  final Color buttonEnabledAlfa = AlfaPalette.alfaUpgradeBlack;
  @override
  final Color buttonDisabledAlfa = AlfaPalette.alfaUpgradeBlack30;

  @override
  Color get activeIndicatorColor => MainPalette.activeIndicatorColor;

  @override
  Color get disabledIndicatorColor => MainPalette.disabledIndicatorColor;

  @override
  Color get buttonAlfaBackground => AlfaPalette.alfaUpgradeBlack;

  @override
  Color get titleBackgroundAlfa => MainPalette.titleBackgroundAlfaColor;

  @override
  Color get titleBackgroundGazprom => MainPalette.titleBackgroundGazpromColor;

  @override
  Color get titleBackgroundMKB => MainPalette.titleBackgroundMKBColor;

  @override
  Color get titleBackgroundOtkritye => MainPalette.titleBackgroundOtkrityeColor;

  @override
  Color get titleBackgroundTinkoff => MainPalette.titleBackgroundTinkoffColor;
}
