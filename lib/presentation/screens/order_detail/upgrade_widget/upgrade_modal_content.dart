import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_status_area_payment.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flight_upgrade_order_status_area.dart';
import 'order_segments_list.dart';

class UpgradeModalContent extends StatelessWidget {
  final OrderDetailsState state;

  const UpgradeModalContent({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isAlfaClubSpecialType = state.activeCard?.passageType == TypePassage.endlessLoungeAndUpgrade;
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        decoration: BoxDecoration(
          color: isAlfaClubSpecialType ? context.colors.textDefault : context.colors.flightOrderBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ModalTopElement(),
            const SizedBox(height: 16),
            Text('Повышение класса перелёта',
                textAlign: TextAlign.center, style: context.textStyles.h2(color: context.colors.textLight)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: (state.order.aeroflotData?.legs?.length ?? 0) + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) {
                    return FlightUpgradeOrderStatus(order: state.order, isPremiumStatusAlfa: isAlfaClubSpecialType);
                  } else {
                    return OrderSegmentsList(
                        leg: state.order.aeroflotData?.legs?[i - 1],
                        passengers: state.order.passengers,
                        isPremiumStatusAlfa: isAlfaClubSpecialType);
                  }
                },
              ),
            ),
            BottomOrderStatusAreaPayment(
              state: state,
              price: state.order.amount,
              canPress: true,
              onAlfaPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onAlfaPayPressed(state.order),
              onTinkoffPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onTinkoffPayPressed(state.order),
              onPayWithCardPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onPayWithCardPressed(state.order),
              onRecurrentPayPressed: () => context.read<OrderDetailsCubit>().payOrderCubit.onRecurrentPayPressed(state.order),
              onAttachCardPressed: context.read<OrderDetailsCubit>().attachCardCubit.openAttachCardScreen,
            ),
          ],
        ),
      ),
    );
  }
}
