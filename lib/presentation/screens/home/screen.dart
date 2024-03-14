import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home/widget/active_products_list.dart';
import 'package:everylounge/presentation/screens/home/widget/app_home_shimmer.dart';
import 'package:everylounge/presentation/screens/home/widget/profile.dart';
import 'package:everylounge/presentation/screens/home/widget/services_list.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:everylounge/presentation/widgets/loaders/app_refresh_indicator.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';

class HomeScreen extends StatelessWidget {
  static const String path = "home_home";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          backgroundColor: context.colors.appBarTransparentBackgroundColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            //<-- For Android SEE HERE (dark icons)
            statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
        ),
      ),
      messageStream: context.read<HomeCubit>().messageStream,
      onMessage: (message) {
        if (message == HomeState.showAddCardModal) {
          context.read<HomeCubit>().openAddCardModal(context);
        } else if (message == HomeState.showAuthorizeModal) {
          context.read<HomeCubit>().openAuthModal(context);
        } else if (message == AttachCardState.successAddBankCardEvent) {
          final bankCardType = context.read<HomeCubit>().state.activeBankCard?.type;
          context.push(AppRoutes.successAddCardModal, extra: bankCardType);
        } else if (message == HomeState.showNeedSetEmailScreen) {
          context.go(AppRoutes.loginNeedSetEmail);
        } else if (message == HomeState.showRateAppModal) {
          context.read<HomeCubit>().modalManager.openRatingModal(context);
        } else {
          context.showSnackbar(message);
        }
      },
      child: AppRefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().getOrderList(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, state) {
            return Scaffold(
              backgroundColor: context.colors.backgroundColor,
              body: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: state.isOrdersLoadingByRefresh ? 0 : 21, bottom: 24, left: 16, right: 16),
                    child: GestureDetector(
                      onTap: () {
                        state.user?.authType != AuthType.anon
                            ? context.push(AppRoutes.profile)
                            : context.go(AppRoutes.loginBottomNavigation);
                      },
                      child: ProfileWidget(
                        user: state.user,
                        activeBankCard: state.activeBankCard,
                        profileLoading: state.profileLoading || state.cardsLoading,
                      ),
                    ),
                  ),
                  if (state.user?.authType != AuthType.anon)
                    ActiveProductsListWidget(
                      activeOrdersList: state.activeOrdersList,
                      ordersLoading: state.ordersLoading,
                    ),
                  state.isServicesLoading
                      ? const AppHomeShimmer(height: 200)
                      : ServicesList(
                          hideMeetAndAssist: state.hideMeetAndAssist,
                          hideUpgrades: state.hideUpgrades,
                          hideLounge: state.hideLounge,
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
