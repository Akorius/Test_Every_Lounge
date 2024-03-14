import 'package:everylounge/presentation/common/theme/main_theme.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTextStyleTheme {
  final BuildContext context;

  AppTextStyleTheme(this.context);

  TextStyle regularButtonText({Color? color}) => AppTextStyles.textLargeRegular(color: color);

  TextStyle regularHintText({Color? color}) => AppTextStyles.textLargeRegular(color: color);

  TextStyle negativeButtonText({Color? color}) => AppTextStyles.textLargeBold(color: color ?? context.colors.buttonNegativeText);

  TextStyle loginInfoButtonText({Color? color}) => AppTextStyles.textNormalRegular(color: color);

  TextStyle bottomMenuText({Color? color}) => AppTextStyles.menuMedium(color: color);

  TextStyle h1({Color? color, bool ruble = false}) => AppTextStyles.h1(color: color, ruble: ruble);

  TextStyle h2({Color? color, bool ruble = false}) => AppTextStyles.h2(color: color, ruble: ruble);

  TextStyle header700({Color? color}) => AppTextStyles.header700(color: color);

  TextStyle header400({Color? color}) => AppTextStyles.header400(color: color);

  TextStyle smallerHeader700({Color? color}) => AppTextStyles.smallerHeader700(color: color);

  TextStyle smallerHeader400({Color? color}) => AppTextStyles.smallerHeader400(color: color);

  TextStyle appBarText({Color? color}) => AppTextStyles.h2(color: color);

  TextStyle textLargeRegular({Color? color, bool ruble = false}) => AppTextStyles.textLargeRegular(color: color, ruble: ruble);

  TextStyle priceText({Color? color, bool ruble = false}) => AppTextStyles.textLargeBold(color: color, ruble: ruble);

  TextStyle dateText({Color? color}) => AppTextStyles.textSmallRegular(color: color);

  TextStyle textLargeRegularLink({Color? color}) => AppTextStyles.textLargeRegular(color: context.colors.textNormalLink);

  TextStyle textNormalRegularGrey() => AppTextStyles.textNormalRegular(color: context.colors.textNormalGrey);

  TextStyle textSmallRegularGrey() => AppTextStyles.textSmallRegular(color: context.colors.textNormalGrey);

  TextStyle textNormalRegular({Color? color, bool ruble = false}) => AppTextStyles.textNormalRegular(color: color, ruble: ruble);

  TextStyle textMiniRegular({Color? color}) => AppTextStyles.textMiniRegular(color: color);

  TextStyle textSmallRegular({Color? color, bool ruble = false}) => AppTextStyles.textSmallRegular(color: color, ruble: ruble);

  TextStyle textOrderDetailsNormal({Color? color, bool ruble = false}) =>
      AppTextStyles.textNormalRegular(color: color, ruble: ruble);

  TextStyle textNormalRegularLink() => AppTextStyles.textNormalRegular(color: context.colors.textNormalLink);

  TextStyle textTinkoffIdButton({Color? color}) => AppTextStyles.tinkoffIdButton(color: color);

  TextStyle textTinkoffPayButton({Color? color}) => AppTextStyles.tinkoffPayButton(color: color);

  TextStyle textAlfaPayButton({Color? color}) => AppTextStyles.alfaPayButton(color: color);

  TextStyle textOrderDetailsLarge({Color? color}) => AppTextStyles.textLargeBold(color: color);

  TextStyle textLargeBold({Color? color, bool ruble = false}) => AppTextStyles.textLargeBold(color: color, ruble: ruble);

  TextStyle textSmallBold({Color? color}) => AppTextStyles.textSmallBold(color: color);

  TextStyle get textFieldHint => AppTextStyles.textLargeRegular(color: context.colors.textFieldHint);

  TextStyle get textFieldBottomHint => AppTextStyles.textSmallRegular(color: context.colors.textFieldHint);

  TextStyle get textFieldError => AppTextStyles.textSmallRegular(color: context.colors.textFieldError);
}

extension AppTextStyleThemeExt on BuildContext {
  AppTextStyleTheme get textStyles => Provider.of<AppTextStyleTheme>(this);
}

class AppTextStyles {
  static TextStyle h1({Color? color, bool ruble = false}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle h2({Color? color, bool ruble = false}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle textSmallBold({Color? color, bool ruble = false}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle textLargeBold({Color? color, bool ruble = false}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle textLargeRegular({
    Color? color,
    bool ruble = false,
  }) =>
      TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle textNormalRegular({
    Color? color,
    bool ruble = false,
  }) =>
      TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle textMiniRegular({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle header700({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle header400({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle smallerHeader700({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle smallerHeader400({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle textSmallRegular({
    Color? color,
    bool ruble = false,
  }) =>
      TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: ruble ? null : 'Lato',
      );

  static TextStyle menuMedium({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 1.4,
        fontFamily: 'Lato',
      );

  static TextStyle tinkoffIdButton({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        height: 1.33,
        fontFamily: 'Neue Haas Unica',
      );

  static TextStyle tinkoffPayButton({Color? color}) => TextStyle(
        color: color ?? MainPalette.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.33,
        fontFamily: 'Lato',
      );

  static TextStyle alfaPayButton({Color? color}) => TextStyle(
        color: color ?? MainPalette.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        height: 1.33,
        fontFamily: 'Neue Haas Unica',
      );
}
