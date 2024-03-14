import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege_card.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'state.dart';

class BankProgramDetailedScreen extends StatelessWidget {
  static const path = "bankProgramDetailed";

  final BankCard bankCard;
  late final LinearGradient backgroundGradient;

  double _topPadding = 0.0;
  SvgPicture? _svgPicture;
  Image? _imagePicture;
  BoxDecoration? _decoration;

  BankProgramDetailedScreen({
    Key? key,
    required this.bankCard,
  }) : super(key: key) {
    switch (bankCard.type) {
      case BankCardType.other:
      case BankCardType.raiffeisen:
      case BankCardType.gazpromDefault:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF062F81), Color(0xFF021B4E)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.otherBankLarge2,
          color: Colors.white,
        );
        _topPadding = 70;
        break;
      case BankCardType.otkrytie:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF3C3C3C), Color(0xFF3C3C3C)],
        );
        _svgPicture = SvgPicture.asset(
          AppImages.otkrytieLogo,
        );
        _topPadding = 202;
        break;
      case BankCardType.moscowCredit:
        _decoration = const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.mosCredBg),
            fit: BoxFit.fitWidth,
          ),
        );
        _imagePicture = Image.asset(
          AppImages.mosCredLogo,
          height: 64,
          width: 187,
        );
        _topPadding = 87;
        break;
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF562737), Color(0xFF2B0D17)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.gazpromPremiumLarge,
          color: Colors.white,
          height: 48,
        );
        _topPadding = 110;
        break;
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPro:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFFF9DE56), Color(0xFFF9DE56)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.tinkoffDefaultLarge,
          color: const Color(0xFF333333),
          height: 48,
        );
        _topPadding = 120;
        break;
      case BankCardType.tinkoffPremium:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF333333), Color(0xFF333333)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.tinkoffPremiumLarge,
          height: 48,
        );
        _topPadding = 120;
        break;
      case BankCardType.tinkoffPrivate:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF41414C), Color(0xFF000000), Color(0xFF12151A)],
          stops: [0, 1, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.tinkoffPrivateLarge,
          height: 48,
        );
        _topPadding = 120;
        break;
      case BankCardType.tochka:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF7139CD), Color(0xFFBF9FF6)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.tochkaProfileLarge,
          height: 48,
        );
        _topPadding = 80;
        break;
      case BankCardType.beelineKZ:
        backgroundGradient = const LinearGradient(
          colors: [Color(0xFF231F20), Color(0xFF231F20)],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        _svgPicture = SvgPicture.asset(
          AppImages.beelineKZLogo,
        );
        _topPadding = 80;
        break;
      case BankCardType.alfaClub:
        _decoration = const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.alfaBg),
            fit: BoxFit.fitWidth,
          ),
        );
        break;
      case BankCardType.alfaPrem:
        _decoration = const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.alfaPremBg),
            fit: BoxFit.fitWidth,
          ),
        );
        _svgPicture = SvgPicture.asset(
          AppImages.alfaTextLogo,
          width: 176,
        );
        _topPadding = 70;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: _decoration ?? BoxDecoration(gradient: backgroundGradient),
      child: CommonScaffold(
        backgroundColor: Colors.transparent,
        messageStream: context.read<BankProgramDetailedCubit>().messageStream,
        onMessage: (message) async {
          if (message == BankProgramDetailedState.successRemoveBankCardEvent) {
            context.pop();
            context.push(AppRoutes.successRemoveCardModal, extra: bankCard);
          } else {
            context.showSnackbar(message);
          }
        },
        appBar: AppAppBar(
          onDeletePressed: bankCard.fake == true &&
                  (isTinkoffTypeCard(bankCard.type) ||
                      bankCard.type == BankCardType.alfaPrem ||
                      bankCard.type == BankCardType.alfaClub)
              ? null
              : () => context.push(
                    AppRoutes.tryRemoveCardModal,
                    extra: {
                      "card": bankCard,
                      "callback": bankCard.fake == true
                          ? context.read<BankProgramDetailedCubit>().removePassage
                          : context.read<BankProgramDetailedCubit>().removeCard,
                    },
                  ),
        ),
        child: BlocBuilder<BankProgramDetailedCubit, BankProgramDetailedState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 34),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight < 710 ? (710 - screenHeight) * 0.3 : _topPadding),
                        if (_svgPicture != null) _svgPicture!,
                        if (_imagePicture != null) _imagePicture!,
                        const Spacer(),
                        PrivilegeCard(
                          bankCard: state.bankCard,
                          loading: state.loading,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
