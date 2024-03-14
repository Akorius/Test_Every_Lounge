import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/state.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area_decoration.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumBottomBar extends StatelessWidget {
  const PremiumBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderPremiumCubit, CreateOrderPremiumState>(
      builder: (context, state) {
        return state.currentStep == PremiumServiceCreateStep.payment
            ? Wrap(
                children: [
                  PaymentButtonArea(
                    activeCard: state.activeCard,
                    passengersCount: state.passengers.length,
                    price: state.createdOrder?.amount ?? 0,
                    payInProgress: state.isLoading,
                    canPress: state.canPressNextStep,
                    cardsLoading: state.cardsLoading,
                    onTinkoffPayPressed: context.read<CreateOrderPremiumCubit>().onTinkoffPayPressed,
                    onPayWithCardPressed:
                        state.canPressNextStep ? context.read<CreateOrderPremiumCubit>().onPayWithCardPressed : null,
                    onRecurrentPayPressed: context.read<CreateOrderPremiumCubit>().onRecurrentPayPressed,
                    onAlfaPayPressed: context.read<CreateOrderPremiumCubit>().onAlfaPayPressed,
                    orderType: OrderType.premium,
                  ),
                  if (PlatformWrap.isIOS)
                    Container(
                      height: 21,
                      decoration: BoxDecoration(color: context.colors.backgroundColor),
                    )
                ],
              )
            : Padding(
                padding: EdgeInsets.only(bottom: PlatformWrap.isIOS ? 21 : 0),
                child: ButtonAreaDecoration(
                  height: context.read<CreateOrderPremiumCubit>().state.isLoading ? 98 : null,
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  child: RegularButton(
                      label: const Text("Продолжить"),
                      onPressed: () => context.read<CreateOrderPremiumCubit>().onNextStepPressed(),
                      canPress: state.canPressNextStep,
                      isLoading: context.read<CreateOrderPremiumCubit>().state.isLoading),
                ),
              );
      },
    );
  }
}
