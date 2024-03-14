import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/entities/upgrade_flight/aero_companies.dart';
import 'package:everylounge/presentation/common/cubit/payment/state.dart';
import 'package:everylounge/presentation/common/loading/loading_dialog.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/extra.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';
import 'widget/upgrade_segments_list.dart';

class CreateUpgradeOrderScreen extends StatelessWidget {
  static const String path = "create_order_upgrade";

  const CreateUpgradeOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateUpgradeOrderCubit, CreateUpgradeOrderState>(
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
        final legs = state.searchedBooking.legs;
        return SafeArea(
          top: false,
          bottom: false,
          child: CommonScaffold(
            backgroundColor: state.activeCard?.passageType == TypePassage.endlessLoungeAndUpgrade
                ? context.colors.appBarTransparentBackgroundColor
                : context.colors.flightOrderBackgroundColor,
            extendBodyBehindAppBar: false,
            messageStream: context.read<CreateUpgradeOrderCubit>().messageStream,
            onMessage: (message) async {
              if (message == PayOrderState.navigateToOrderDetailsScreen || message == PayOrderState.navigateToSuccess) {
                //TODO проверить нужно ли добавить pop up "успешно оплачено"
                context.go(AppRoutes.homeBottomNavigation);
                context.push(
                  AppRoutes.orderDetailsModal,
                  extra: context.read<CreateUpgradeOrderCubit>().state.createdOrder,
                );
              } else if (message == PayOrderState.navigateToTinkoffWebView) {
                context.push(
                  AppRoutes.acquiringWebViewTinkkoff,
                  extra: AcquiringExtraObject(
                    activeCardType: context.read<CreateUpgradeOrderCubit>().state.activeCard?.type,
                    paymentUrl: context.read<CreateUpgradeOrderCubit>().payOrderCubit.state.webViewPaymentUri!,
                    onPaymentSuccess: () => context.read<CreateUpgradeOrderCubit>().payOrderCubit.onWebViewReturned(true),
                    onPaymentFailure: () => context.read<CreateUpgradeOrderCubit>().payOrderCubit.onWebViewReturned(false),
                    showTinkoffWarning: true,
                  ),
                );
              } else {
                context.showSnackbar(message);
              }
            },
            appBar: AppBar(
              leading: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: BackArrowButton(),
              ),
              centerTitle: true,
              title: Text(
                'Данные о бронировании',
                style: context.textStyles.textLargeBold(color: context.colors.textLight),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            child: Column(
              children: [
                Text(state.currentCompany.name, style: context.textStyles.textLargeRegular(color: context.colors.textLight)),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: legs.length + 2,
                        itemBuilder: (BuildContext context, int i) {
                          if (i == legs.length + 1) {
                            return const SizedBox(height: 186);
                          } else if (i == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Center(
                                child: Text(
                                  state.searchedBooking.pnrLocator,
                                  style: context.textStyles.h1(color: context.colors.textLight),
                                ),
                              ),
                            );
                          } else {
                            return UpgradeSegmentsList(
                              leg: legs[i - 1],
                              state: state,
                            );
                          }
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: PaymentButtonArea(
                            activeCard: state.activeCard,
                            passengersCount: state.searchedBooking.passengers.length,
                            price: state.currentPrice ?? 0,
                            payInProgress: state.isLoading || state.payInProgress,
                            canPress: state.canPress,
                            cardsLoading: false,
                            orderType: OrderType.upgrade,
                            onPayWithCardPressed: (state.currentPrice ?? 0) > 0
                                ? context.read<CreateUpgradeOrderCubit>().onPayWithCardPressed
                                : null,
                            onRecurrentPayPressed: context.read<CreateUpgradeOrderCubit>().onRecurrentPayPressed,
                            onAttachCardPressed: context.read<CreateUpgradeOrderCubit>().onAttachCardPressed,
                            onTinkoffPayPressed: context.read<CreateUpgradeOrderCubit>().onTinkoffPayPressed,
                            onAlfaPayPressed: context.read<CreateUpgradeOrderCubit>().onAlfaPayPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (PlatformWrap.isIOS)
                  Container(
                    height: MediaQuery.of(context).padding.bottom,
                    width: MediaQuery.of(context).size.width,
                    color: context.colors.cardBackground,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
