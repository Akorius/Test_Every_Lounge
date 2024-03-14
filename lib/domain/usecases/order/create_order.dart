import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/order/create_order_object.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/premium/premuim_create_order_object.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';

abstract class CreateOrderUseCase {
  ///Создаём заказ
  Future<Result<Order>> createLounge(CreateOrderObject createOrderObject);

  Future<Result<Order>> createPremiumService(PremiumCreateOrderObject createOrderObject);
}

class CreateOrderUseCaseImplMock implements CreateOrderUseCase {
  @override
  Future<Result<Order>> createLounge(CreateOrderObject createOrderObject) async {
    return Result.success(Order.mock());
  }

  @override
  Future<Result<Order>> createPremiumService(PremiumCreateOrderObject createOrderObject) async {
    return Result.success(Order.mock());
  }
}

class CreateOrderUseCaseImpl implements CreateOrderUseCase {
  final OrderApi _orderApi = getIt();
  final UserStorage _userStorage = getIt();
  final GetUserOrdersUseCase _getUserOrdersUseCase = getIt();

  @override
  Future<Result<Order>> createLounge(CreateOrderObject createOrderObject) async {
    ///Добавляем нехватающюю информацию для создания заказа
    createOrderObject.contacts.phone = _userStorage.phone ?? "";
    createOrderObject.contacts.email = _userStorage.email;

    ///Создаём заказ
    late final Order order;
    try {
      order = await _orderApi.createLoungeOrder(createOrderObject);
      _getUserOrdersUseCase.addOrderToStream(order);
    } catch (e, s) {
      Log.exception(e, s, "CreateOrderUseCaseImpl");
      return Result.failure("Не удалось создать заказ.");
    }
    return Result.success(order);
  }

  @override
  Future<Result<Order>> createPremiumService(PremiumCreateOrderObject createOrderObject) async {
    ///Добавляем нехватающюю информацию для создания заказа
    createOrderObject.contacts.phone = _userStorage.phone ?? "";
    createOrderObject.contacts.email = _userStorage.email;

    ///Создаём заказ
    try {
      final Order order = await _orderApi.createPremiumServiceOrder(createOrderObject);
      _getUserOrdersUseCase.addOrderToStream(order);
      return Result.success(order);
    } catch (e, s) {
      Log.exception(e, s, "CreatePremiumOrderUseCaseImpl");
      return Result.failure("Не удалось создать заказ.");
    }
  }
}
