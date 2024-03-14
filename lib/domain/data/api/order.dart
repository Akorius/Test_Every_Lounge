import 'package:everylounge/domain/entities/order/create_order_object.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';
import 'package:everylounge/domain/entities/order/order_check_info.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/premium/premuim_create_order_object.dart';
import 'package:everylounge/domain/entities/order/updated_order.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';

abstract class OrderApi {
  Future<OrderData> getOrders({int? limit, List<OrderStatus>? statuses, int? page});

  Future<List<UpdatedOrder>> getUpdatedOrders();

  Future<Order> getOrder(String orderId);

  Future<Order> createLoungeOrder(CreateOrderObject createOrderObject);

  Future<Order> createPremiumServiceOrder(PremiumCreateOrderObject createOrderObject);

  Future<Order> getPricePremiumServiceOrder(PremiumCreateOrderObject createOrderObject);

  Future<PassageCheck> checkPassage(PassageCheckInfo info);

  Future<bool> payOrder(String orderId, String transactionId, AcquiringType acquiringType);

  Future<bool> payOrderByPassage(String orderId, {String? tinkoffToken});

  Future<bool> finishOrder(String orderId);
}
