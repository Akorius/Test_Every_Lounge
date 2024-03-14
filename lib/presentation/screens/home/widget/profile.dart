import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/widget/home_shimmer.dart';
import 'package:everylounge/presentation/widgets/shared/bank_program_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({
    super.key,
    required this.activeBankCard,
    this.user,
    required this.profileLoading,
  }) {
    tochka = activeBankCard?.type == BankCardType.tochka;
  }

  final User? user;
  final BankCard? activeBankCard;
  final bool profileLoading;
  late final bool tochka;

  @override
  Widget build(BuildContext context) {
    final child = profileLoading
        ? const HomeShimmer(
            height: 80,
          )
        : Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colors.cardBackground,
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(24), // Image radius
                        child: user?.profile.avatar != 0
                            ? Image.network("${ApiClient.filesUrl}${user?.profile.avatar}", fit: BoxFit.cover)
                            : Image.asset(AppImages.avatarLogo),
                      ),
                    ),
                    const SizedBox(width: 12),
                    user?.authType != AuthType.anon
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user?.profile.firstName.isNotEmpty ?? false ? user!.profile.firstName : 'Ваш профиль',
                                  style: context.textStyles.h1(color: context.colors.textDefault)),
                              BankProgramLogo(
                                bankCard: activeBankCard,
                                fromProfile: true,
                              ),
                            ],
                          )
                        : Text("Профиль", style: context.textStyles.h2(color: context.colors.textDefault)),
                    const Spacer(),
                    SvgPicture.asset(AppImages.arrowRight),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          );
    return child;
  }
}
