import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/main_theme.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBarWebView extends StatelessWidget {
  Widget? title;
  Color backgroundColor = MainPalette.mainBlue2;
  final BankCardType? activeCard;

  CustomAppBarWebView({super.key, required this.activeCard});

  _checkCardType(BuildContext context) {
    switch (activeCard) {
      case BankCardType.gazpromDefault:
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
        title = SvgPicture.asset(AppImages.gazpromPremiumLarge);
        backgroundColor = context.colors.titleBackgroundGazprom;

      case BankCardType.alfaClub:
      case BankCardType.alfaPrem:
        title = SvgPicture.asset(AppImages.alfaTextLogo);
        backgroundColor = context.colors.titleBackgroundAlfa;

      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
        title = SvgPicture.asset(AppImages.tinkoffDefaultRULarge);
        backgroundColor = context.colors.titleBackgroundTinkoff;

      case BankCardType.moscowCredit:
        title = Image.asset(AppImages.mosCredLogo, height: 30);
        backgroundColor = context.colors.titleBackgroundMKB;

      case BankCardType.otkrytie:
        title = SvgPicture.asset(AppImages.otkrytieLogo, height: 30);
        backgroundColor = context.colors.titleBackgroundOtkritye;

      case BankCardType.raiffeisen:
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
      case BankCardType.other:
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkCardType(context);
    return AppBar(
      backgroundColor: backgroundColor,
      title: title,
      centerTitle: true,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: const BackArrowButton(),
    );
  }
}
