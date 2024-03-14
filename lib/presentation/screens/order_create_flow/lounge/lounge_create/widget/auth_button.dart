import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.lounge,
    required this.isLoading,
  });

  final Lounge lounge;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
        child: RegularButton(
          isLoading: isLoading,
          height: 54,
          label: Text(
            "Авторизироваться",
            style: context.textStyles.textLargeBold(color: context.colors.textLight),
          ),
          onPressed: () async {
            context.go(AppRoutes.loginBottomNavigation);
            context.read<LoginBottomNavigationCubit>().setIndex(0);
          },
        ),
      ),
    );
  }
}
