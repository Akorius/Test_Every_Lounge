import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BankProgramLogo extends StatelessWidget {
  final BankCard? bankCard;
  final Color? color;
  late final String bankSvgLogo;
  final bool fromProfile;
  double? size;
  String? bankImageLogo;

  BankProgramLogo({
    super.key,
    required this.bankCard,
    this.fromProfile = false,
    this.color,
  }) {
    switch (bankCard?.type) {
      case null:
      case BankCardType.raiffeisen:
      case BankCardType.other:
        bankSvgLogo = AppImages.unknownBank;
        break;
      case BankCardType.gazpromDefault:
        bankSvgLogo = AppImages.gazpromDefault;
        break;
      case BankCardType.gazpromPremium:
        bankSvgLogo = AppImages.gazpromPremium;
        break;
      case BankCardType.gazpromPrivate:
        bankSvgLogo = AppImages.gazpromDefault;
        break;
      case BankCardType.tinkoffPro:
      case BankCardType.tinkoffDefault:
        bankSvgLogo = AppImages.tinkoffDefault;
        break;
      case BankCardType.tinkoffPremium:
        bankSvgLogo = AppImages.tinkoffPremium;
        break;
      case BankCardType.tinkoffPrivate:
        bankSvgLogo = AppImages.tinkoffPrivate;
        break;
      case BankCardType.tochka:
        bankSvgLogo = AppImages.tochkaProfile;
        break;
      case BankCardType.otkrytie:
        bankSvgLogo = AppImages.otkrytieProfile;
        break;
      case BankCardType.beelineKZ:
        bankSvgLogo = AppImages.beelineKZProfile;
        break;
      case BankCardType.moscowCredit:
        bankImageLogo = AppImages.mosCredProfile;
        break;
      case BankCardType.alfaClub:
        bankSvgLogo = AppImages.alfaLogo;
        break;
      case BankCardType.alfaPrem:
        if (fromProfile == true) {
          bankSvgLogo = AppImages.alfaPremProfileLogo;
        } else {
          bankSvgLogo = AppImages.alfaPremBankLogo;
          size = 20;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (bankImageLogo != null)
        ? Image.asset(
            bankImageLogo!,
            height: 18,
            width: 54,
          )
        : SvgPicture.asset(
            bankSvgLogo,
            color: color,
            width: size,
            height: size,
          );
  }
}
