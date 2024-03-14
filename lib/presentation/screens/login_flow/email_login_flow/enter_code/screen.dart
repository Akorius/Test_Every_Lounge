import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/inputs/code_text_field.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/shared/code_resend.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';

class EnterCodeScreen extends StatelessWidget {
  static const path = "enterCode";

  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      messageStream: context.read<EnterCodeCubit>().messageStream,
      onMessage: (message) async {
        if (message == EnterCodeState.navigateToMainScreen) {
          context.go(AppRoutes.homeBottomNavigation);
        } else {
          context.showSnackbar(message);
        }
      },
      appBar: const AppAppBar(),
      child: BlocBuilder<EnterCodeCubit, EnterCodeState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 27, top: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  "Введите проверочный код",
                  textAlign: TextAlign.center,
                  style: context.textStyles.h1(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Мы выслали его на ваш e-mail ",
                  textAlign: TextAlign.center,
                  style: context.textStyles.textLargeRegular(),
                ),
              ),
              const SizedBox(height: 38),
              CodeTextField(
                onCodeChanged: context.read<EnterCodeCubit>().onCodeChanged,
                enabled: state.canEditPin,
              ),
              const SizedBox(height: 24),
              RegularButton(
                label: const Text("Продолжить"),
                onPressed: () => context.read<EnterCodeCubit>().onContinuePressed(),
                canPress: state.canPress,
                isLoading: state.loading,
              ),
              const SizedBox(height: 24),
              CodeResendWidget(
                onResentPressed: () {
                  context.read<EnterCodeCubit>().onResendPressed();
                },
                onTimerEnd: context.read<EnterCodeCubit>().onTimerEnd,
                showTimer: state.showTimer,
                secondsLeft: 60,
              ),
            ],
          ),
        );
      }),
    );
  }
}
