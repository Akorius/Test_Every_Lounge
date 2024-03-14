import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/terminal.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/info_for_employees.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/lounge_ticket_top.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/note_for_employees.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_details_for_print.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_status_area_payment.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_status_area_ticket.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoungeScreenContent extends StatelessWidget {
  final OrderDetailsState state;

  const LoungeScreenContent({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<OrderDetailsCubit>();
    return Scaffold(
      backgroundColor: context.colors.loginInfoCardText,
      appBar: AppBar(
        backgroundColor: context.colors.loginInfoCardText,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: BackArrowButton(),
        ),
        actions: [
          if (toShowShareContentStatuses.contains(state.order.status))
            IconButton(
              padding: const EdgeInsets.all(0),
              splashRadius: 23,
              icon: Container(
                padding: const EdgeInsets.all(7),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: context.colors.appBarBackArrowBackground,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: context.colors.appBarBackArrowBorder,
                    )),
                child: SvgPicture.asset(
                  AppImages.impart,
                  color: context.colors.appBarBackArrowColor,
                ),
              ),
              onPressed: () {
                shareContent(context);
              },
            ),
          const SizedBox(
            width: 16,
          )
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Данные заказа',
          textAlign: TextAlign.center,
          style: context.textStyles.textLargeBold(color: context.colors.buttonPressed),
        ),
      ),
      bottomNavigationBar: BottomOrderStatusAreaPayment(
        isOnlinePayment: bloc.isPassageOver,
        state: state,
        price: state.order.amount ~/ state.order.passengers.length,
        canPress: bloc.canPress(),
        onAlfaPayPressed: () => bloc.payOrderCubit.onAlfaPayPressed(state.order),
        onTinkoffPayPressed: () => bloc.payOrderCubit.onTinkoffPayPressed(state.order),
        onPayWithCardPressed: () => bloc.payOrderCubit.onPayWithCardPressed(state.order),
        onRecurrentPayPressed: () => bloc.payOrderCubit.onRecurrentPayPressed(state.order),
        onAttachCardPressed: bloc.attachCardCubit.openAttachCardScreen,
        onUsePassPressed: () => bloc.payOrderCubit.onUsePassPressed(
          state.order,
          isTinkoff: state.activeCard?.availableTinkoffPasses == true,
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    if (state.order.lounge.name.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 28, right: 28),
                        child: Text(
                          state.order.lounge.name,
                          textAlign: TextAlign.center,
                          style: context.textStyles.h2(color: context.colors.buttonPressed),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28, right: 28, top: 4, bottom: 4),
                      child: Text(
                          state.order.lounge.airport.name.isEmpty
                              ? state.order.lounge.airport.city
                              : "${state.order.lounge.airport.city}, ${state.order.lounge.airport.name}",
                          textAlign: TextAlign.center,
                          style: context.textStyles.textLargeRegular(color: context.colors.buttonPressed.withOpacity(0.6))),
                    ),
                    Terminal(state.order.lounge.terminal),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
                      child: Text(
                          "Для прохода в бизнес-зал предъявите посадочный талон и открытый заказ в Вашем мобильном приложении",
                          textAlign: TextAlign.center,
                          style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled)),
                    ),
                    if (bloc.isLoungeMe)
                      GestureDetector(
                        onTap: () => showNoteForEmployees(context),
                        child: const InfoForEmployees(),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoungeTicketTop(
                      order: state.order,
                      pnr: bloc.getPNR(),
                      needMaskPnr: bloc.needMaskPnr(),
                      isPartnerOrg: bloc.isPartnerOrg,
                      needLoadQrForLoungeMe: bloc.needLoadQrForLoungeMe,
                      isLoungeMe: bloc.isLoungeMe,
                      isDragonPass: bloc.isDragonPass,
                      isAirportOrgs: bloc.isAirportOrgs,
                    ),
                    BottomOrderStatusAreaTicket(order: state.order),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  shareContent(BuildContext context) {
    var bloc = context.read<OrderDetailsCubit>();
    return bloc.shareFile(
      OrderDetailForPrint(
        order: state.order,
        isLoungeMe: bloc.isLoungeMe,
        isDragonPass: bloc.isDragonPass,
        isAirportOrgs: bloc.isAirportOrgs,
        pnr: bloc.getPNR(),
        needMaskPnr: bloc.needMaskPnr(),
        isPartnerOrg: bloc.isPartnerOrg,
        needLoadQrForLoungeMe: bloc.needLoadQrForLoungeMe,
      ),
      context,
    );
  }
}
