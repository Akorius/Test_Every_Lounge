import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/about_premium.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_status_area_payment.dart';
import 'package:everylounge/presentation/screens/order_detail/premium_widget/paid_content.dart';
import 'package:everylounge/presentation/screens/order_detail/premium_widget/widget/premium_body_content.dart';
import 'package:everylounge/presentation/screens/order_detail/premium_widget/widget/premium_instruction.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PremiumScreenContent extends StatelessWidget {
  PremiumScreenContent({super.key, required this.state});

  final OrderDetailsState state;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.profileBackgroundColor,
      bottomNavigationBar: BottomOrderStatusAreaPayment(
        state: state,
        price: state.order.amount,
        canPress: true,
        onAlfaPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onAlfaPayPressed(state.order),
        onTinkoffPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onTinkoffPayPressed(state.order),
        onPayWithCardPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onPayWithCardPressed(state.order),
        onRecurrentPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onRecurrentPayPressed(state.order),
        onAttachCardPressed: context.read<OrderDetailsCubit>().attachCardCubit.openAttachCardScreen,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: context.colors.profileBackgroundColor,
                  child: Column(
                    children: [
                      AboutPremium(
                          state.order.premiumService!.airportTitle,
                          state.order.premiumService!.flightDirection,
                          state.order.premiumService?.name ?? "",
                          (state.order.flightInfo?.length ?? 0) > 1
                              ? InnerDestinationType.transit
                              : (state.order.flightInfo?.first.getInnerDestinationType() ?? InnerDestinationType.departure),
                          state.order.premiumService!.terminal),
                    ],
                  ),
                ),
                Instruction(state.order),
                PremiumBodyContent(state.order),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                  child: Container(
                      constraints: const BoxConstraints(minHeight: 64),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: context.colors.backgroundColor,
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: PaidContentPremiumServices(state: state)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 8,
            child: BackArrowButton(
              onTap: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
