import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/cubit/payment/state.dart';
import 'package:everylounge/presentation/common/loading/loading_dialog.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/additional_conditions.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/amenities/amenities_body.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/bottom_details.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/create_order/passenger_card.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/create_order/passengers_counter.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/sliver_app_bar.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/terminal.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/extra.dart';
import 'package:everylounge/presentation/widgets/appbars/appbar.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoungeDetailsScreen extends StatelessWidget {
  static const String path = "lounge";
  final ServiceSearchType type;

  LoungeDetailsScreen({
    super.key,
    required this.type,
  });

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: CommonScaffold(
        appBar: AppAppBar(
          backgroundColor: context.colors.backgroundColor,
          height: 0,
        ),
        messageStream: context.read<LoungeCubit>().messageStream,
        onMessage: (message) async {
          handleStreamMessage(message, context);
        },
        backgroundColor: context.colors.backgroundColor,
        bottomNavigationBar: const BottomDetails(),
        child: BlocConsumer<LoungeCubit, LoungeState>(
          listener: (context, state) {},
          listenWhen: (previousState, currentState) {
            if (currentState.isPayByCardLoading && !previousState.isPayByCardLoading) {
              showLoadingDialog(context);
            }
            if (!currentState.isPayByCardLoading && previousState.isPayByCardLoading) {
              Navigator.pop(context);
            }
            return true;
          },
          builder: (BuildContext context, state) {
            return NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerScrolled) => [
                CustomSliverAppBar(
                  state.lounge.gallery ?? [],
                  state.lounge.name,
                  (newOpacity) => context.read<LoungeCubit>().changeTitleOpacity(newOpacity),
                ),
              ],
              //TODO дубликат от лаундж, рассмотреть возможность обьединения
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: state.titleOpacity,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                          child: AutoSizeText(
                            state.lounge.name,
                            maxLines: 2,
                            minFontSize: 14,
                            style: context.textStyles.h1(color: context.colors.textBlue),
                          ),
                        ),
                      ),
                      Terminal(state.lounge.terminal),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(state.lounge.location ?? "",
                            style: context.textStyles.textNormalRegular(color: context.colors.textNormalGrey)),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Scheduler(state.lounge.schedule),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      AdditionalConditions(state.lounge.minAdultAge, state.lounge.maxStayDuration),
                      AmenitiesBody(state.isAuth),
                      if (state.isAuth)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              PassengerDecoration(
                                isSecondCard: false,
                                isLastCard: false,
                                content: PassengerContent(
                                  nameController: context.read<LoungeCubit>().nameController
                                    ..text = state.passenger.firstName
                                    ..selection =
                                        TextSelection.fromPosition(TextPosition(offset: state.passenger.firstName.length)),
                                  lastNameController: context.read<LoungeCubit>().lastNameController
                                    ..text = state.passenger.lastName
                                    ..selection =
                                        TextSelection.fromPosition(TextPosition(offset: state.passenger.lastName.length)),
                                  nameErrorText: state.nameError,
                                  lastNameErrorText: state.lastNameError,
                                  canEdit: state.canChangeName,
                                  translit: state.isTranslitNames,
                                ),
                              ),
                              PassengerDecoration(
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  child: PassengersCounter(
                                      isPassageOver: context.read<LoungeCubit>().isPassageOver,
                                      isLoading: state.cardsLoading,
                                      onPressedPlus: () => context.read<LoungeCubit>().increasePassengers(),
                                      onPressedMinus: () => context.read<LoungeCubit>().decreasePassengers(),
                                      count: state.passengersCount - 1,
                                      activeBankCard: state.activeBankCard,
                                      isRichedMaxGuests: context.read<LoungeCubit>().isRichedMaxGuests,
                                      maxPassengers: context.read<LoungeCubit>().maxPassengers,
                                      alfaLimitEnable: context.read<LoungeCubit>().isPassLimitEnable &&
                                          state.activeBankCard?.type == BankCardType.alfaClub,
                                      disableAdditionPassengers: context.read<LoungeCubit>().needDisableAdditionPassengers),
                                ),
                                isSecondCard: true,
                                isLastCard: true,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void handleStreamMessage(String message, BuildContext context) {
    if (message.contains(AttachCardState.successAddBankCardEvent)) {
      final attachedCard = context.read<LoungeCubit>().state.activeBankCard?.type;
      if (attachedCard != null) {
        context.push(AppRoutes.successAddCardModal, extra: attachedCard);
      }
    } else if (message.contains(LoungeState.navigateToTinkoffWebView) || message == PayOrderState.navigateToTinkoffWebView) {
      context.push(
        AppRoutes.acquiringWebViewTinkkoff,
        extra: AcquiringExtraObject(
          activeCardType: context.read<LoungeCubit>().state.activeBankCard?.type,
          paymentUrl: context.read<LoungeCubit>().state.webViewPaymentUri!,
          onPaymentSuccess: () => context.read<LoungeCubit>().payOrderCubit?.onWebViewReturned(true),
          onPaymentFailure: () => context.read<LoungeCubit>().payOrderCubit?.onWebViewReturned(false),
          showTinkoffWarning: true,
        ),
      );
    } else if (message.contains(PayOrderState.navigateToOrderDetailsScreen) ||
        message == PayOrderState.navigateToOrderDetailsScreen ||
        message.contains(PayOrderState.navigateToSuccess)) {
      if (message.contains(PayOrderState.navigateToSuccess)) {
        if (context.read<LoungeCubit>().state.createdOrder?.acquiringType == AcquiringType.passages) {
          context.showTopSnackbar("Ваш заказ успешно оформлен");
        } else {
          context.showTopSnackbar("Ваш заказ успешно оплачен");
        }
      }
      context.go(AppRoutes.homeBottomNavigation);
      context.push(
        AppRoutes.orderDetailsScreen,
        extra: context.read<LoungeCubit>().state.createdOrder,
      );
      context.read<LoungeCubit>().sendEventSuccess(eventName[orderCreated]!);
    } else {
      context.showSnackbar(message);
    }
  }
}
