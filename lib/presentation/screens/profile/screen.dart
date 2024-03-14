import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/cubit.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/card_list_area.dart';
import 'package:everylounge/presentation/screens/profile/widget/profile_area.dart';
import 'package:everylounge/presentation/screens/profile/widget/profile_bottom_bar.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/appbars/settings_button.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  static const String path = "profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (BuildContext context, state) {
        return CommonScaffold(
          messageStream: context.read<ProfileCubit>().messageStream,
          onMessage: (message) async {
            if (message == AttachCardState.successAddBankCardEvent) {
              final attachedCard = context.read<ProfileCubit>().attachCardCubit.state.attachedCard?.type;
              context.push(AppRoutes.successAddCardModal, extra: attachedCard);
            } else {
              context.showSnackbar(message);
            }
          },
          backgroundColor: state.isLoading ? context.colors.profileBackgroundColor : context.colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: context.colors.profileBackgroundColor,
            leading: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: BackArrowButton(),
            ),
            actions: const [
              SettingsButton(),
              SizedBox(width: 12),
            ],
            centerTitle: true,
            elevation: 0,
            title: Text(
              'Профиль',
              textAlign: TextAlign.center,
              style: context.textStyles.textLargeBold(color: context.colors.textLight),
            ),
          ),
          bottomNavigationBar: ProfileBottomBar(
            hideBanks: state.hideBanks,
            isCardAttaching: state.isCardAttaching,
          ),
          child: state.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AppCircularProgressIndicator.large(
                    color: context.colors.lightProgress,
                  ),
                )
              : CustomRefreshIndicator(
                  onRefresh: () => context.read<ProfileCubit>().updateCards(),
                  builder: MaterialIndicatorDelegate(
                    displacement: 180,
                    builder: (context, controller) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: AppCircularProgressIndicator(),
                      );
                    },
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics().applyTo(const ClampingScrollPhysics()),
                    children: [
                      ProfileArea(state: state),
                      CardsListArea(
                        state: state,
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
