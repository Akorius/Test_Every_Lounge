import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/entities/order/create_order_object.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';
import 'package:everylounge/domain/entities/order/order_check_info.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/premium/premuim_create_order_object.dart';
import 'package:everylounge/domain/entities/order/updated_order.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';

class OrderApiImpl implements OrderApi {
  final Dio _client = getIt();

  @override
  Future<OrderData> getOrders({int? limit, List<OrderStatus>? statuses, int? page}) async {
    final params = {
      if (limit != null) "limit": limit,
      if (statuses != null) "status[]": statuses.map((status) => status.index).toList(),
      if (page != null) "page": page,
    };
    final response = await _client.get("orders/", queryParameters: params);
    final data = (response.data as Map<String, dynamic>)['data'];
    final list = data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
    return OrderData(listOrders: List<Order>.from(list), totalItems: (response.data as Map<String, dynamic>)["meta"]["total"]);
  }

  @override
  Future<List<UpdatedOrder>> getUpdatedOrders() async {
    final response = await _client.get("orders/statuses");
    final data = (response.data as Map<String, dynamic>)['data'];
    final list = data.map((e) => UpdatedOrder.fromJson(e as Map<String, dynamic>)).toList();
    return List<UpdatedOrder>.from(list);
  }

  @override
  Future<Order> getOrder(String orderId) async {
    final response = await _client.post("orders/$orderId");
    return Order.fromJson(response.data["data"]);
  }

  @override
  Future<Order> createLoungeOrder(CreateOrderObject createOrderObject) async {
    final response = await _client.post(
      "orders/",
      data: createOrderObject.toJson(),
    );
    return Order.fromJson(response.data["data"]);
  }

  @override
  Future<Order> createPremiumServiceOrder(PremiumCreateOrderObject createOrderObject) async {
    final response = await _client.post(
      "premium-orders/",
      data: createOrderObject.toJson(),
    );
    return Order.fromJson(response.data["data"]);
  }

  @override
  Future<Order> getPricePremiumServiceOrder(PremiumCreateOrderObject createOrderObject) async {
    final response = await _client.post(
      "premium-orders/rate",
      data: createOrderObject.toJson(),
    );
    return Order.fromJson(response.data["data"]);
  }

  @override
  Future<bool> payOrder(String orderId, String transactionId, AcquiringType acquiringType) async {
    final response = await _client.post(
      "orders/$orderId/pay",
      data: FormData.fromMap({"transaction": transactionId, "acquiring_type": acquiringType.index}),
    );
    return response.data["code"] == 200;
  }

  @override
  Future<bool> payOrderByPassage(String orderId, {String? tinkoffToken}) async {
    final response = await _client.post(
      "orders/$orderId/pay/passage",
      data: {
        if (tinkoffToken != null) 'tinkoff_token': tinkoffToken,
      },
    );
    return response.data["code"] == 200;
  }

  @override
  Future<bool> finishOrder(String orderId) async {
    final response = await _client.post(
      "orders/$orderId/finish",
    );
    return response.data["code"] == 200;
  }

  @override
  Future<PassageCheck> checkPassage(PassageCheckInfo info) async {
    final response = await _client.post("orders/check", data: info.toJson());
    return PassageCheck.fromJson(response.data["data"]);
  }
}
