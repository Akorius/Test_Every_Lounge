import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/inputs/email_text_field.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';

class NeedSetEmailScreen extends StatelessWidget {
  static const path = "needSetEmailScreen";

  const NeedSetEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      extendBodyBehindAppBar: true,
      messageStream: context.read<NeedSetEmailCubit>().messageStream,
      resizeToAvoidBottomInset: false,
      onMessage: (message) async {
        if (message == NeedSetEmailState.navigateToCodeSend) {
          context.push(AppRoutes.loginEnterCode, extra: true);
        } else if (message == NeedSetEmailState.logout) {
          context.go(AppRoutes.loginBottomNavigation);
        } else {
          context.showSnackbar(message);
        }
      },
      appBar: const AppAppBar(),
      child: BlocBuilder<NeedSetEmailCubit, NeedSetEmailState>(builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                ),
              ),
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 110),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 27, top: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 54),
                                child: Text(
                                  "Введите e-mail",
                                  textAlign: TextAlign.center,
                                  style: context.textStyles.h1(),
                                ),
                              ),
                              const SizedBox(height: 46),
                              EmailTextField(
                                emailController: context.read<NeedSetEmailCubit>().emailController,
                                errorText: state.emailError,
                                onChanged: context.read<NeedSetEmailCubit>().onEmailChanged,
                                enabled: state.canPress,
                                onClear: () {
                                  context.read<NeedSetEmailCubit>().onClearEmail();
                                },
                              ),
                              const SizedBox(height: 24),
                              RegularButton(
                                label: const Text("Продолжить"),
                                onPressed: context.read<NeedSetEmailCubit>().onEmailContinuePressed,
                                canPress: state.canPress,
                                isLoading: state.emailLoading,
                              ),
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40.0),
                              child: InkWell(
                                onTap: () => context.read<NeedSetEmailCubit>().logOut(),
                                child: Text(
                                  'Выйти из аккаунта',
                                  style: context.textStyles.textLargeBold(
                                    color: context.colors.textFieldError,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
