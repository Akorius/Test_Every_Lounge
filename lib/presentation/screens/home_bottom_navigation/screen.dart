import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/feedback/cubit.dart';
import 'package:everylounge/presentation/screens/feedback/screen.dart';
import 'package:everylounge/presentation/screens/history/screen.dart';
import 'package:everylounge/presentation/screens/home/cubit.dart';
import 'package:everylounge/presentation/screens/home/screen.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/state.dart';
import 'package:everylounge/presentation/widgets/bottom_navigation/home.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';

class HomeBottomNavigationScreen extends StatelessWidget {
  static const String path = "home";

  const HomeBottomNavigationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CommonScaffold(
        messageStream: context.read<HomeBottomNavigationCubit>().messageStream,
        onMessage: (message) {
          if (message == HomeBottomState.showUpdateAppModal) {
            context.read<HomeBottomNavigationCubit>().openUpdateModal(context);
          } else if (message == HomeBottomState.showUpdateAppScreen) {
            context.go(AppRoutes.updateAppScreen);
          } else {
            context.showSnackbar(message);
          }
        },
        child: BlocBuilder<HomeBottomNavigationCubit, HomeBottomState>(
          builder: (context, state) => state.isCheckUpdating
              ? const Padding(padding: EdgeInsets.all(8), child: EveryAppLoader.large())
              : Material(
                  color: (state.currentScreen == 1 && state.orders?.isEmpty == true)
                      ? context.colors.profileBackgroundColor
                      : context.colors.cardBackground,
                  child: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: state.currentScreen,
                          children: [
                            BlocProvider<HomeCubit>(
                              create: (context) => getIt.call<HomeCubit>(),
                              child: const HomeScreen(),
                            ),
                            const HistoryScreen(),
                            BlocProvider<FeedbackCubit>(
                              create: (context) => getIt(),
                              child: const ContactsScreen(),
                            )
                          ],
                        ),
                      ),
                      HomeBottomMenu(
                        onItemSelected: context.read<HomeBottomNavigationCubit>().setIndex,
                        selectedIndex: state.currentScreen,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
