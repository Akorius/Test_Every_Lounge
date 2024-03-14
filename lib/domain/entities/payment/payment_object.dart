import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';

class PaymentObject {
  final String serviceName;
  final String orderId;
  final String aaServiceId;

  final int pricePerOnePenny;
  final double quantity;
  final int fullAmountPenny;

  final bool isAirportForeign;
  final OrderType orderType;

  PaymentObject({
    required this.serviceName,
    required this.orderId,
    required this.aaServiceId,
    required this.pricePerOnePenny,
    required this.quantity,
    required this.fullAmountPenny,
    required this.isAirportForeign,
    required this.orderType,
  });

  PaymentObject.fromOrder(Order order)
      : this(
          serviceName: order.serviceName(),
          orderId: order.id.toString(),
          aaServiceId: order.pnrTransaction ?? order.pnr,
          pricePerOnePenny: order.amount * 100 ~/ order.passengers.length,
          quantity: order.passengers.length.toDouble(),
          fullAmountPenny: (order.amount * 100).toInt(),
          isAirportForeign: order.lounge.airport.countryCode != "RU",
          orderType: order.type!,
        );
}
