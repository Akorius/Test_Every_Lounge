import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/auth_button.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/info_payment.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/pay_by_pass_modal.dart';
import 'package:everylounge/presentation/widgets/shared/payment_area/payment_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomDetails extends StatelessWidget {
  const BottomDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoungeCubit, LoungeState>(
      builder: (BuildContext context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.isAuth
                ? Column(
                    children: [
                      if (!state.cardsLoading && state.needShowAttention)
                        InfoPaymentWidget(
                          state.activeBankCard,
                          context.read<LoungeCubit>().isFirstAttention,
                          () => context.read<LoungeCubit>().hideAttention(),
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: !state.cardsLoading && state.needShowAttention ? context.colors.buttonDisabled : null,
                        ),
                        child: PaymentButtonArea(
                          activeCard: state.activeBankCard,
                          passengersCount: state.passengersCount,
                          onAlfaPayPressed: context.read<LoungeCubit>().onAlfaPayPressed,
                          price: state.price,
                          payInProgress: state.isLoading,
                          canPress: context.read<LoungeCubit>().canPress,
                          cardsLoading: state.cardsLoading,
                          onTinkoffPayPressed: context.read<LoungeCubit>().onTinkoffPayPressed,
                          onPayWithCardPressed:
                              context.read<LoungeCubit>().canPress ? context.read<LoungeCubit>().onPayWithCardPressed : null,
                          onRecurrentPayPressed: context.read<LoungeCubit>().onRecurrentPayPressed,
                          onAttachCardPressed: () => context.read<LoungeCubit>().attachCardCubit?.openAttachCardScreen(
                                cardAttachedCallback: context.read<LoungeCubit>().onCardAttached,
                              ),
                          isOnlinePayment: context.read<LoungeCubit>().isPassageOver,
                          onUsePassPressed: () => showPayByPassModal(
                            context,
                            callback: context.read<LoungeCubit>().onUsePassPressed,
                            count: state.passengersCount,
                          ),
                          orderType: OrderType.lounge,
                        ),
                      ),
                    ],
                  )
                : AuthButton(
                    lounge: state.lounge,
                    isLoading: state.isLoading,
                  ),
            if (PlatformWrap.isIOS)
              Container(
                height: MediaQuery.of(context).padding.bottom / 2,
                width: MediaQuery.of(context).size.width,
                color: context.colors.cardBackground,
              )
          ],
        );
      },
    );
  }
}
