import 'dart:async';

import 'package:collection/collection.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/gprc.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/data/storages/orders.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/updated_order.dart';
import 'package:everylounge/domain/entities/protobuf/order.pb.dart' as proto;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetUserOrdersUseCase {
  Future<Result<OrderData>> get({int? limit, List<OrderStatus>? statuses, int? page, bool? needRefresh = false});

  Future<Result<Order?>> getOrder({required String orderId});

  Future<Result<List<Order>>> getNextOrdersPage({int? page, List<OrderStatus>? statuses, int? limit});

  Stream<List<Order>> get stream;

  cleanOrders();

  void addOrderToStream(Order order);
}

class GetUserOrdersUseCaseImplMock implements GetUserOrdersUseCase {
  final BehaviorSubject<List<Order>> _orderController = BehaviorSubject();

  @override
  cleanOrders() {}

  @override
  addOrderToStream(Order order) {}

  @override
  Future<Result<Order?>> getOrder({required String orderId}) async {
   return Result.success(null); 
  }

  @override
  Future<Result<OrderData>> get({int? limit, List<OrderStatus>? statuses, int? page, bool? needRefresh = false}) async {
    return Result.success(OrderData(listOrders: [], totalItems: 1));
  }

  @override
  Stream<List<Order>> get stream => _orderController.stream;

  @override
  Future<Result<List<Order>>> getNextOrdersPage({int? page, List<OrderStatus>? statuses, int? limit}) async {
    return Result.success([]);
  }
}

class GetUserOrdersUseCaseImpl implements GetUserOrdersUseCase {
  final OrderApi _orderApi = getIt();
  final OrderGrpcService _orderGrpcService = getIt();
  final TokensStorage _tokensStorage = getIt();
  final OrdersStorage _ordersStorage = getIt();
  final BehaviorSubject<List<Order>> _orderController = BehaviorSubject();
  Timer? _timer;

  @override
  addOrderToStream(Order order) {
    saveOrdersInStorage([order]);
    _addOrdersToStream(_ordersStorage.orders ?? []);
  }

  _addOrdersToStream(List<Order> event) {
    _orderController.add(event);
    if (PlatformWrap.isWeb) {
      _watchOrdersStatusesWeb(event);
    }
  }

  _addStorageOrdersToStream() {
    _orderController.add(_ordersStorage.orders!);
    if (PlatformWrap.isWeb) {
      _watchOrdersStatusesWeb(_ordersStorage.orders!);
    }
  }

  @override
  Future<Result<Order?>> getOrder({required String orderId}) async {
    late final Order orderData;
    try {
      orderData = await _orderApi.getOrder(orderId);
    } catch (e, s) {
      Log.exception(e, s, "GetUserOrdersUseCaseImpl");
      return Result.failure('Не удалось получить заказы.');
    }
    saveOrdersInStorage([orderData], needRefresh: false);

    ///Добавляем заказы в стриму
    _addStorageOrdersToStream();
    return Result.success(orderData);
  }

  @override
  Future<Result<List<Order>>> getNextOrdersPage({int? page, List<OrderStatus>? statuses, int? limit}) async {
    final OrderData res;
    try {
      res = await _orderApi.getOrders(page: page, statuses: statuses, limit: limit);
    } catch (e, s) {
      Log.exception(e, s, "GetUserOrdersNextPageUseCaseImpl");
      return Result.failure('Не удалось загрузить новую страницу заказов.');
    }
    saveOrdersInStorage(res.listOrders);
    _addOrdersToStream(_ordersStorage.orders ?? []);
    return Result.success(_ordersStorage.orders ?? []);
  }

  @override
  Future<Result<OrderData>> get({
    int? page,
    int? limit,
    List<OrderStatus>? statuses,
    bool? needRefresh = false,
  }) async {
    ///Получаем заказы из бэкенда
    late final OrderData ordersData;
    try {
      ordersData = await _orderApi.getOrders(limit: limit, statuses: statuses);
    } catch (e, s) {
      Log.exception(e, s, "GetUserOrdersUseCaseImpl");
      return Result.failure('Не удалось получить заказы.');
    }
    saveOrdersInStorage(ordersData.listOrders, needRefresh: needRefresh);

    ///Добавляем заказы в стриму
    _addOrdersToStream(_ordersStorage.orders ?? []);
    return Result.success(ordersData);
  }

  void saveOrdersInStorage(List<Order> orders, {bool? needRefresh = false}) {
    try {
      if (needRefresh == true || _ordersStorage.orders == null) {
        _ordersStorage.orders = orders;
      } else {
        var tempOrders = _ordersStorage.orders;
        for (var o in orders) {
          final int index = tempOrders?.indexWhere((element) => element.id == o.id) ?? -1;
          if (index != -1) {
            tempOrders?[index] = o;
          } else {
            tempOrders?.add(o);
          }
        }
        _ordersStorage.orders = tempOrders;
      }
    } catch (e, s) {
      Log.exception(e, s, "GetUserOrdersUseCaseImpl");
    }
  }

  @override
  Stream<List<Order>> get stream {
    final orders = _ordersStorage.orders;
    if (orders != null) {
      _addOrdersToStream(orders);
    }
    return _orderController.stream.map((orderList) {
      ///На каждое обновление стримы мы обновляем список отслеживаемых заказов
      if (!PlatformWrap.isWeb) {
        _watchOrdersStatuses(orderList);
      }
      return orderList;
    });
  }

  @override
  cleanOrders() {
    _addOrdersToStream([]);
    _ordersStorage.orders = null;
  }

  _watchOrdersStatuses(List<Order> orderList) {
    for (Order element in orderList) {
      if (!watchedOrders.contains(element.id) && !finishedStatuses.contains(element.status)) {
        ///Добавляем заказ в отслеживаемые заказы
        watchedOrders.add(element.id);

        ///Начинаем отслеживать заказ
        _watchOrderStatus(element.id);
      }
    }
  }

  _watchOrderStatus(int orderId) async {
    Logger().d("Начинаем слушать заказ с id: $orderId", "_watchOrderStatus");

    ///Начинаем слушать заказ
    StreamSubscription<proto.Order>? orderSubscription;
    orderSubscription =
        _orderGrpcService.orderStream(proto.UpdateOrderRequest(token: _tokensStorage.accessToken, id: orderId)).listen(
            (newOrder) {
              ///Берём текущий список заказов из стримы заказов и ищем обновленный заказ в нём
              final int? index = _orderController.valueOrNull?.indexWhere((element) => element.id == newOrder.id);

              ///Если в списке заказов есть заказ, для которого изменился статус,
              ///то выпускаем новый список с изменённым заказом
              ///и сохраняем его в базу данных
              if ((index ?? -1) != -1) {
                final List<Order> newList = [..._orderController.valueOrNull!];
                final oldOrder = newList[index!];
                if (oldOrder.status.index != newOrder.status.value) {
                  Log.message(
                    "Обновление для заказа ${newOrder.id}: ${oldOrder.status} => ${newOrder.status}",
                    sender: "_watchOrderStatus",
                    skipInProduction: true,
                  );
                  newList[index] = newList[index].updateFromProto(order: newOrder);
                  _addOrdersToStream(newList);
                  _ordersStorage.orders = newList;
                }
              }

              ///Если заказ перешёл в конечный статус, то перестаём его отслеживать
              if (finishedStatusesProto.contains(newOrder.status)) {
                orderSubscription?.cancel();
                watchedOrders.remove(newOrder.id);
              }
            },
            cancelOnError: false,
            onError: (e, s) {
              ///Если произошла ошибка, отменяем подписку и начинаем слушать заказ снова через 20 секунд
              // Log.message(e.toString(), sender: "orderSubscription", skipInProduction: true);
              orderSubscription?.cancel();
              Future.delayed(seconds(20)).then((value) => _watchOrderStatus(orderId));
            });
  }

  _watchOrdersStatusesWeb(List<Order> orderList, [bool timerWasRecreated = false]) {
    /// Завершаем предыдущий таймер на каждое обновление стримы
    _timer?.cancel();
    // print("ThisТаймер был отменён. В стриму было выпущено новое событие: ${!timerWasRecreated} или таймер был перезапущен по своей воле: $timerWasRecreated");

    ///Определяем заказы для отслеживания на каждое обновление стримы
    if (!timerWasRecreated) {
      watchedOrdersWeb = orderList.where((element) => !finishedStatuses.contains(element.status)).toList();
    }

    ///Если есть заказы, которые нужно отслеживать, то пересоздаём таймер отслеживания
    if (watchedOrdersWeb.isNotEmpty) {
      // print("ThisЗаказы для отслеживания не пусты: $watchedOrdersWeb");
      _timer = Timer(seconds(20), () async {
        ///Получаем последние статусы заказов.
        late final List<UpdatedOrder> lastOrdersStates;
        try {
          lastOrdersStates = await _orderApi.getUpdatedOrders();
          // print("ThisПоследнее состояние заказов с бэкенда: $lastOrdersStates");
        } catch (e, s) {
          Log.exception(e, s);
          _watchOrdersStatusesWeb(orderList, true);
          return;
        }

        ///Теперь для каждого отслеживаемого заказа нужно проверить, изменился ли статус. Если хотя бы один изменился
        ///обновляем стриму заказа
        bool ordersNeedUpdate = false;
        for (final watchedOrder in watchedOrdersWeb) {
          ///Получаем последний статус

          final lastOrderState = lastOrdersStates.firstWhereOrNull((element) => element.id == watchedOrder.id);

          ///Если статус изменился, то обновляеем заказ в списке который мы потом отправим в стриму, отмечаем, что
          ///есть обновления.
          if (lastOrderState != null &&
              (watchedOrder.status != lastOrderState.status || watchedOrder.qrId != lastOrderState.qrId)) {
            final int index = orderList.indexWhere((element) => element.id == watchedOrder.id);
            // print("ThisЗаказ до обновления: ${orderList[index]}");
            orderList[index] = orderList[index].updateFromUpdated(lastOrderState);
            // print("ThisЗаказ после обновления: ${orderList[index]}");
            ordersNeedUpdate = true;
          }
        }

        ///Если заказы требуют обновления, то добавляем в стриму обновленный список
        if (ordersNeedUpdate) {
          // print("ThisЗаказы потребовали обновления, новый список заказов: $orderList");
          _addOrdersToStream(orderList);
          _ordersStorage.orders = orderList;
        } else {
          // print("ThisЗаказы НЕ потребовали обновления");
          _watchOrdersStatusesWeb(orderList, true);
        }
      });
    } else {
      // print("ThisЗаказы для отслеживания пусты: $watchedOrdersWeb");
    }
  }

  final List<int> watchedOrders = [];
  List<Order> watchedOrdersWeb = [];
}
