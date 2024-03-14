import 'package:everylounge/presentation/common/cubit/payment/state.dart';
import 'package:everylounge/presentation/common/loading/loading_dialog.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/about_premium.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/premium_bottom_bar.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/step_holder.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/steps/steps_header.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/extra.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';

class CreateOrderPremiumScreen extends StatefulWidget {
  static const String path = "create_order_vip";

  const CreateOrderPremiumScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateOrderPremiumScreen> createState() => _CreateOrderPremiumScreenState();
}

class _CreateOrderPremiumScreenState extends State<CreateOrderPremiumScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderPremiumCubit, CreateOrderPremiumState>(
      listener: (context, state) {},
      listenWhen: (previousState, currentState) {
        if (previousState.currentStep != currentState.currentStep &&
            currentState.currentStep == PremiumServiceCreateStep.passengers) {
          context.read<CreateOrderPremiumCubit>().checkCanPressNextStep();
        }
        if (currentState.isPayByCardLoading && !previousState.isPayByCardLoading) {
          showLoadingDialog(context);
        }
        if (!currentState.isPayByCardLoading && previousState.isPayByCardLoading) {
          Navigator.pop(context);
        }
        return true;
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            onTapBack(state, context);
            return Future.value(false);
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: CommonScaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: state.currentStep == PremiumServiceCreateStep.payment
                  ? context.colors.profileBackgroundColor
                  : context.colors.backgroundColor,
              messageStream: context.read<CreateOrderPremiumCubit>().messageStream,
              onMessage: (message) async {
                if (message.contains(CreateOrderPremiumState.navigateToTinkoffWebView)) {
                  context.push(
                    AppRoutes.acquiringWebViewTinkkoff,
                    extra: AcquiringExtraObject(
                      activeCardType: context.read<CreateOrderPremiumCubit>().state.activeCard?.type,
                      paymentUrl: context.read<CreateOrderPremiumCubit>().state.webViewPaymentUri!,
                      onPaymentSuccess: () => context.read<CreateOrderPremiumCubit>().payOrderCubit.onWebViewReturned(true),
                      onPaymentFailure: () => context.read<CreateOrderPremiumCubit>().payOrderCubit.onWebViewReturned(false),
                      showTinkoffWarning: true,
                    ),
                  );
                } else if (message.contains(CreateOrderPremiumState.navigateToOrderDetailsScreen) ||
                    message == PayOrderState.navigateToOrderDetailsScreen ||
                    message == PayOrderState.navigateToSuccess) {
                  context.go(AppRoutes.homeBottomNavigation);
                  context.push(
                    AppRoutes.orderDetailsScreen,
                    extra: context.read<CreateOrderPremiumCubit>().state.createdOrder,
                  );
                } else {
                  context.showSnackbar(message);
                }
              },
              bottomNavigationBar: const PremiumBottomBar(),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        Container(
                          color: context.colors.profileBackgroundColor,
                          child: Column(
                            children: [
                              AboutPremium(
                                state.service.airportTitle,
                                state.service.flightDirection,
                                state.service.name,
                                state.destinationType,
                                state.service.terminal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                                child: StepsHeader(step: state.currentStep),
                              ),
                            ],
                          ),
                        ),
                        if (state.currentStep != PremiumServiceCreateStep.payment)
                          Container(
                            height: 20,
                            color: context.colors.profileBackgroundColor,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.colors.backgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        StepHolder(
                          step: state.currentStep,
                          type: state.destinationType,
                          direction: state.service.flightDirection,
                          countryCode: state.service.airport.countryCode,
                          isTransit: state.service.isTransit,
                          onTapForScroll: () => {
                            Future.delayed(const Duration(milliseconds: 500)).then(
                              (value) => _controller.animateTo(
                                _controller.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              ),
                            )
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 4,
                    left: 8,
                    child: BackArrowButton(
                      onTap: () => onTapBack(state, context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  onTapBack(CreateOrderPremiumState state, BuildContext context) {
    return {
      if (state.currentStep == PremiumServiceCreateStep.flight)
        GoRouter.of(context).pop()
      else
        context.read<CreateOrderPremiumCubit>().onStepBack()
    };
  }
}
