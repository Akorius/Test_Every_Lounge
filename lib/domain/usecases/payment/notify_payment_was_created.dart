import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';

abstract class NotifyPaymentWasCreatedUseCase {
  ///Оповещаем бэкенд, что оплата для заказа создана
  Future<Result> notify(String orderId, String transactionId, AcquiringType acquiringType);
}

class NotifyPaymentWasCreatedUseCaseImpl implements NotifyPaymentWasCreatedUseCase {
  final OrderApi _orderApi = getIt();

  @override
  Future<Result> notify(String orderId, String transactionId, AcquiringType acquiringType) async {
    ///Оповещаем бэкенд, что оплата для заказа создана
    late final bool success;
    try {
      success = await _orderApi.payOrder(orderId, transactionId, acquiringType);
    } catch (e, s) {
      Log.exception(e, s, "NotifyPaymentWasCreatedUseCase");
      return Result.failure("Не удалось создать платёж в системе Every Lounge.");
    }
    return Result.success(success);
  }
}
