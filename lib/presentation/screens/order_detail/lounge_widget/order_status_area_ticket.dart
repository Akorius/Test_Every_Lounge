import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/paid_content.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/passengers_content.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_bottom.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_middle.dart';
import 'package:flutter/material.dart';

class BottomOrderStatusAreaTicket extends StatelessWidget {
  final Order order;
  late final List<Widget> widgets;

  BottomOrderStatusAreaTicket({
    Key? key,
    required this.order,
  }) : super(key: key) {
    final passengerContent = PassengerContent(passengers: order.passengers);
    switch (order.status) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
      case OrderStatus.cancelled:
        widgets = [
          TicketBottom(
            height: 72,
            isLounge: true,
            child: passengerContent,
          ),
          const SizedBox(height: 24),
        ];
        break;
      case OrderStatus.paid:
      case OrderStatus.completed:
      case OrderStatus.bankPaid:
      case OrderStatus.visited:
      case OrderStatus.unknown:
      case OrderStatus.rejected:
      case OrderStatus.expired:
        widgets = [
          TicketMiddle(height: 84, child: passengerContent),
          TicketBottom(
            isLounge: true,
            height: 72,
            child: PaidContent(order: order),
          ),
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: widgets);
  }
}
