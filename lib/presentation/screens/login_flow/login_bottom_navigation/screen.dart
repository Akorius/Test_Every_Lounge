import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/presentation/screens/login_flow/info/screen.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/cubit.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/screen.dart';
import 'package:everylounge/presentation/widgets/bottom_navigation/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBottomNavigationScreen extends StatelessWidget {
  static const String path = "login";

  const LoginBottomNavigationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<LoginBottomNavigationCubit, int>(
        builder: (context, state) => Material(
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: state,
                  children: [
                    BlocProvider<OtherLoginCubit>(
                      create: (context) => getIt(),
                      child: const OtherLoginScreen(),
                    ),
                    const LoginInfoScreen(),
                  ],
                ),
              ),
              LoginBottomMenu(
                onItemSelected: context.read<LoginBottomNavigationCubit>().setIndex,
                selectedIndex: state,
              )
            ],
          ),
        ),
      ),
    );
  }
}
