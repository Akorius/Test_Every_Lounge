import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/content/bank_card_content.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/content/passes_content.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/content/tinkoff_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CardWidget extends StatelessWidget {
  final BankCard bankCard;
  final double height;
  late final Widget child;
  late final String svgLogo;
  String? imageLogo;

  CardWidget({
    Key? key,
    required this.bankCard,
    this.height = 64,
  }) : super(key: key) {
    switch (bankCard.type) {
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPro:
        svgLogo = AppImages.cardSmallCircleTinkoffYellow;
        child = TinkoffContent(cardType: bankCard.type);
        break;
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
        svgLogo = AppImages.cardSmallCircleTinkoffBlack;
        child = TinkoffContent(cardType: bankCard.type, passCount: bankCard.passesCount);
        break;
      case BankCardType.tochka:
        svgLogo = AppImages.tochka;
        child = PassesContent(bankCard: bankCard, text: "Бонусный счёт Точка");
        break;
      case BankCardType.beelineKZ:
        svgLogo = AppImages.beelineKZ;
        child = PassesContent(bankCard: bankCard, text: "Beeline Business Kazakhstan");
        break;
      case BankCardType.gazpromDefault:
      case BankCardType.gazpromPrivate:
      case BankCardType.gazpromPremium:
        svgLogo = AppImages.cardSmallCircleGazProm;
        child = BankCardContent(bankCard: bankCard);
        break;
      case BankCardType.otkrytie:
        svgLogo = AppImages.cardSmallCircleOtkrytie;
        child = BankCardContent(bankCard: bankCard);
        break;
      case BankCardType.moscowCredit:
        imageLogo = AppImages.cardSmallCircleMkb;
        child = BankCardContent(bankCard: bankCard);
        break;
      case BankCardType.alfaClub:
        svgLogo = AppImages.cardSmallCircleAlfa;
        child = PassesContent(bankCard: bankCard, text: "А-Клуб");
        break;
      case BankCardType.alfaPrem:
        svgLogo = AppImages.cardSmallCircleAlfaPrem;
        child = BankCardContent(bankCard: bankCard);
        break;
      case BankCardType.other:
      case BankCardType.raiffeisen:
      default:
        svgLogo = AppImages.otherBank;
        child = BankCardContent(bankCard: bankCard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: context.colors.cardBackground,
      highlightColor: context.colors.buttonNegativePressed,
      splashColor: context.colors.buttonNegativePressed,
      highlightElevation: 0,
      elevation: 0,
      padding: const EdgeInsets.all(12),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      height: height,
      minWidth: double.infinity,
      onPressed: () => context.push(AppRoutes.bankProgramDetailed, extra: bankCard),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (imageLogo != null)
              ? Image.asset(
                  imageLogo!,
                  height: 40,
                )
              : SvgPicture.asset(
                  svgLogo,
                  height: (bankCard.type == BankCardType.alfaClub && bankCard.fake == false) ? 32 : 40,
                ),
          const SizedBox(width: 12),
          child,
          const Spacer(),
          SvgPicture.asset(
            AppImages.chevron,
            color: context.colors.textNormalGrey,
          ),
        ],
      ),
    );
  }
}
