import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/main_theme.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/info_for_employees.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/lounge_ticket_top.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/note_for_employees.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/order_status_area_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailForPrint extends StatelessWidget {
  const OrderDetailForPrint({
    Key? key,
    required this.order,
    required this.isLoungeMe,
    required this.isDragonPass,
    required this.isAirportOrgs,
    required this.pnr,
    required this.needMaskPnr,
    required this.isPartnerOrg,
    required this.needLoadQrForLoungeMe,
  }) : super(key: key);

  final Order order;
  final bool isLoungeMe;
  final bool isDragonPass;
  final bool isAirportOrgs;
  final String pnr;
  final bool needMaskPnr;
  final bool isPartnerOrg;
  final bool needLoadQrForLoungeMe;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppTheme>(create: (context) => MainAppTheme()),
        Provider<AppTextStyleTheme>(create: (context) => AppTextStyleTheme(context)),
      ],
      builder: (context, child) => Container(
        color: context.colors.loginInfoCardText,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: [
                        if (order.lounge.name.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 28, right: 28),
                            child: Text(
                              order.lounge.name,
                              textAlign: TextAlign.center,
                              style: context.textStyles.h2(color: context.colors.buttonPressed),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28, right: 28, top: 4),
                          child: Text(
                              order.lounge.airport.name.isEmpty
                                  ? order.lounge.airport.city
                                  : "${order.lounge.airport.city}, ${order.lounge.airport.name}",
                              textAlign: TextAlign.center,
                              style: context.textStyles.textLargeRegular(color: context.colors.buttonPressed.withOpacity(0.6))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                          child: Text(
                              "Для прохода в бизнес-зал предъявите посадочный талон и открытый заказ в Вашем мобильном приложении",
                              textAlign: TextAlign.center,
                              style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled)),
                        ),
                        if (isLoungeMe)
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
                          order: order,
                          pnr: pnr,
                          needMaskPnr: needMaskPnr,
                          isPartnerOrg: isPartnerOrg,
                          needLoadQrForLoungeMe: needLoadQrForLoungeMe,
                          isLoungeMe: isLoungeMe,
                          isDragonPass: isDragonPass,
                          isAirportOrgs: isAirportOrgs,
                        ),
                        BottomOrderStatusAreaTicket(order: order),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
