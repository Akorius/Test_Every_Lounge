import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class NotifyPaymentWasPaidUseCase {
  ///Оповещаем бэкенд, что заказ оплачен
  Future<Result> notify(String orderId);
}

class NotifyPaymentWasPaidUseCaseImpl implements NotifyPaymentWasPaidUseCase {
  final OrderApi _orderApi = getIt();

  @override
  Future<Result> notify(String orderId) async {
    ///Оповещаем бэкенд, что заказ оплачен
    late final bool success;
    try {
      success = await _orderApi.finishOrder(orderId);
    } catch (e, s) {
      Log.exception(e, s, "NotifyPaymentWasPaidUseCase");
      return Result.failure("Не удалось уведомить систему Every Lounge, что заказ был оплачен.");
    }
    return Result.success(success);
  }
}
