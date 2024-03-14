import 'package:everylounge/core/config.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/loading/loading_dialog.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/widget/or_divider.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/widget/terms_of_use.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/inputs/email_text_field.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/social_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

import 'cubit.dart';
import 'state.dart';

class OtherLoginScreen extends StatefulWidget {
  static const path = "otherLogin";

  const OtherLoginScreen({Key? key}) : super(key: key);

  @override
  State<OtherLoginScreen> createState() => _OtherLoginScreenState();
}

class _OtherLoginScreenState extends State<OtherLoginScreen> with WidgetsBindingObserver {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<OtherLoginCubit>().hideTinkoffLoader();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: CommonScaffold(
        extendBodyBehindAppBar: true,
        messageStream: context.read<OtherLoginCubit>().messageStream,
        resizeToAvoidBottomInset: false,
        onMessage: (message) async {
          if (message == OtherLoginState.navigateToAlfaWebView) {
            context
                .push<AlfaIdResult>(
                  AppRoutes.loginAlfaWeb,
                  extra: context.read<OtherLoginCubit>().state.alfaAuthLink,
                )
                .then((result) => context.read<OtherLoginCubit>().onAlfaWebViewReturned(result));
          } else if (message == OtherLoginState.navigateToTinkoffWebView) {
            context
                .push<TinkoffIdResult>(AppRoutes.loginTinkoffWeb)
                .then((result) => context.read<OtherLoginCubit>().onTinkoffWebViewReturned(result));
          } else if (message == OtherLoginState.navigateToCodeSend) {
            context.push(AppRoutes.loginEnterCode, extra: false);
          } else if (message == OtherLoginState.navigateToMainScreen) {
            context.go(AppRoutes.homeBottomNavigation);
          } else {
            context.showSnackbar(message);
          }
        },
        appBar: AppAppBar(
            onClosePressed: alfaBuild
                ? null
                : () {
                    context.read<OtherLoginCubit>().sendEvent(eventName[skipAuthButtonClick]!);
                    context.go(AppRoutes.homeBottomNavigation);
                  }),
        child: BlocConsumer<OtherLoginCubit, OtherLoginState>(
          listener: (context, state) {},
          listenWhen: (previousState, currentState) {
            if (currentState.tinkoffLoading && !previousState.tinkoffLoading) {
              showLoadingDialog(context);
            }
            if (!currentState.tinkoffLoading && previousState.tinkoffLoading) {
              Navigator.pop(context);
            }
            return true;
          },
          builder: (context, state) {
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
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    emailController: emailController,
                                    errorText: state.emailError,
                                    onChanged: (text) => {
                                      setState(() {
                                        context.read<OtherLoginCubit>().checkCanPressEmail(text);
                                        context.read<OtherLoginCubit>().cleanEmailError();
                                      })
                                    },
                                    enabled: state.canPress,
                                    onClear: () {
                                      setState(() {
                                        context.read<OtherLoginCubit>().checkCanPressEmail('');
                                        emailController.clear();
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  RegularButton(
                                    label: const Text("Продолжить"),
                                    onPressed: () => context.read<OtherLoginCubit>().onEmailContinuePressed(emailController.text),
                                    canPress: state.canPressEmailLogin,
                                    isLoading: state.emailLoading,
                                  ),
                                  const SizedBox(height: 32),
                                  if (!alfaBuild) ...[
                                    const OrDivider(),
                                    const SizedBox(height: 40),
                                  ],
                                  Column(
                                    children: [
                                      if (PlatformWrap.isIOS)
                                        SocialSignInButton(
                                          text: "Apple ID",
                                          icon: AppImages.apple,
                                          onPressed: () {
                                            context.read<OtherLoginCubit>().onApplePressed();
                                          },
                                          canPress: state.canPress,
                                          isLoading: state.appleLoading,
                                        ),
                                      if (PlatformWrap.isIOS) const SizedBox(height: 8),
                                      if (!alfaBuild && !PlatformWrap.isWeb)
                                        SocialSignInButton(
                                          text: 'Google',
                                          icon: AppImages.google,
                                          onPressed: () {
                                            context.read<OtherLoginCubit>().onGooglePressed();
                                          },
                                          canPress: state.canPress,
                                          isLoading: state.googleLoading,
                                        ),
                                      if (!state.hideAlfa) ...[
                                        const SizedBox(height: 8),
                                        SocialSignInButton(
                                          text: "",
                                          icon: AppImages.alfaIdLogo,
                                          onPressed: () {
                                            context.read<OtherLoginCubit>().onAlfaIdPressed();
                                          },
                                          canPress: state.canPress,
                                          isLoading: state.alfaLoading,
                                        ),
                                      ],
                                      if (!state.hideTinkoff) ...[
                                        const SizedBox(height: 8),
                                        SocialSignInButton(
                                          text: "",
                                          icon: AppImages.tinkoffIdLogo,
                                          onPressed: () {
                                            context.read<OtherLoginCubit>().onTinkoffIdPressed();
                                          },
                                          canPress: state.canPress,
                                          isLoading: false,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const TermOfUse(),
                            ],
                          ),
                        ),
                      ),
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

  @override
  void deactivate() {
    emailController.dispose();
    super.deactivate();
  }
}
