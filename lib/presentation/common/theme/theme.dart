import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class AppTheme {
  /// Regular Button
  Color get buttonEnabled;

  Color get buttonEnableRed;

  Color get buttonEnabledText;

  Color get buttonDisabled;

  Color get buttonDisabledText;

  Color get buttonPressed;

  Color get buttonPressedText;

  Color get buttonNegative;

  Color get buttonBlack;

  Color get buttonNegativeText;

  Color get buttonNegativePressed;

  Color get buttonNegativeDisabledText;

  Color get buttonNegativeBorder;

  Color get buttonEnabledGazProm;

  Color get buttonEnabledOtkrytie;

  Color get buttonEnabledMkb;

  ///Progress
  Color get lightProgress;

  Color get darkProgress;

  Color get blueProgress;

  ///Button in Login Info
  Color get buttonInfoBorder;

  Color get buttonInfoBorderBlue;

  Color get buttonInfoText;

  ///Tinkoff Button
  Color get buttonTinkoffBackground;

  ///Alfa button
  Color get buttonAlfaBackground;

  ///Cards
  Color get textCard;

  Color get cardBackground;

  Color get cardBackgroundGazPromPremium;

  Color get cardSelectedBorder;

  Color get cardShadow;

  Color get cardShadow2;

  Color get loginInfoCardText;

  ///Фоны
  Color get backgroundColor;

  Color get switcherColor;

  Color get tochkaWrapperBackground;

  Color get bottomSheetBackgroundColor;

  Color get orderDetailsBackgroundColor;

  Color get orderDetailsBackgroundTopColor;

  Color get profileBackgroundColor;

  Color get avatarBackgroundColor;

  Color get dividerGray;

  Color get sliderSelected;

  Color get sliderUnselected;

  Color get searchAirportWarningBackground;

  Color get flightOrderBackgroundColor;

  Color get flightTiketRedBackgroundColor;

  Color get blackOpacity;

  ///Search
  Color get searchBackground;

  Color get searchBorder;

  Color get searchIcon;

  ///Appbars
  Color get appBarBackArrowColor;

  Color get appBarBackArrowBackground;

  Color get appBarText;

  Color get appBarBackArrowBorder;

  Color get appBarTransparentBackgroundColor;

  ///Borders
  Color get dashBorder;

  Color get lightDashBorder;

  Color get profileAvatarBorder;

  Color get modalTopElementColor;

  ///Other
  Color get dateText;

  Color get hintText;

  ///Иконки
  Color get iconSelected;

  Color get iconUnselected;

  ///Текст
  Color get textNormalGrey;

  Color get textGreen;

  Color get textDefault;

  Color get textDate;

  Color get textLight;

  Color get textProfileSetting;

  Color get textMiddleBlue;

  Color get textAddCard;

  Color get textOrderDetails;

  Color get textOrderDetailsBlue;

  Color get textOrderDetailsImpart;

  Color get textOrderDetailsTitle;

  Color get textNormalLink;

  Color get textBlue;

  Color get textDarkPurple;

  Color get textError;

  Color get textAirportCity;

  Color get textHistoryDate;

  Color get textLoungeProduct;

  ///Поля ввода
  Color get textFieldHint;

  Color get textFieldBorderEnabled;

  Color get textFieldBorderFocused;

  Color get textFieldError;

  ///Orders Status
  Color get created;

  Color get confirmed;

  Color get paid;

  Color get completed;

  Color get cancelled;

  Color get initPay;

  Color get bankPaid;

  Color get visited;

  Color get expired;

  Color get defaultStatus;

  ///Alfa upgrades
  Color get upgradePaidStatus;

  Color get upgradeCompleteStatus;

  Color get upgradeCancelledStatus;

  LinearGradient get alfaUpgradeStatusBackground;

  LinearGradient get upgradeAeroCompanyButtonBackground;

  Color get buttonEnabledAlfa;

  Color get buttonDisabledAlfa;

  Color get activeIndicatorColor;

  Color get disabledIndicatorColor;

  Color get backgroundAirportInfoBlock;

  //Pay title colors
  Color get titleBackgroundMKB;

  Color get titleBackgroundOtkritye;

  Color get titleBackgroundGazprom;

  Color get titleBackgroundAlfa;

  Color get titleBackgroundTinkoff;
}

extension AppThemeExt on BuildContext {
  AppTheme get colors => Provider.of<AppTheme>(this, listen: false);
}
