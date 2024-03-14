import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/localization.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_created.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_paid.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart' as t;

import 'init_pay.dart';

abstract class PayRecurrentPaymentUseCase {
  Future<Result<String>> pay(PaymentObject paymentObject);
}

class PayRecurrentPaymentUseCaseImpl implements PayRecurrentPaymentUseCase {
  final InitAcquiringUseCase _initAcquiringUseCase = getIt();
  final InitPayUseCase _initPayUseCase = getIt();
  final NotifyPaymentWasCreatedUseCase _notifyPaymentWasCreatedUseCase = getIt();
  final NotifyPaymentWasPaidUseCase _notifyPaymentWasPaidUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final DeveloperModeStorage _developerModeStorage = getIt();

  @override
  Future<Result<String>> pay(PaymentObject paymentObject) async {
    ///Получаем rebillId активной карты
    late final int activeCardRebillId;
    final activeCardResult = await _getCardsUseCase.active(notFake: true);
    if (!activeCardResult.isSuccess) {
      return Result.failure(activeCardResult.message);
    }
    activeCardRebillId = activeCardResult.value.rebillId;

    ///Инициализируем эквайринг нужными кредами
    final acquiringResult = await _initAcquiringUseCase.init(
      shop: ClientShop.attachCard,
    );
    if (!acquiringResult.isSuccess) {
      return Result.failure(acquiringResult.message);
    }
    final acquiring = acquiringResult.value;

    ///Иницииализируем платёж
    final initRequestResult = _initPayUseCase.init(
      paymentObject: paymentObject,
      payWithOneRuble: _developerModeStorage.payWithOneRuble,
      localization: Localization.ru,
    );
    if (!initRequestResult.isSuccess) {
      return Result.failure(acquiringResult.message);
    }

    final initResponse = await acquiring.init(initRequestResult.value);
    if (initResponse.success != true) {
      final message = initResponse.details ?? initResponse.message;
      Log.exception(Exception("Не удалось создать платёж: $message"), null, "PayRecurrentPaymentUseCase");
      return Result.failure("Не удалось создать платёж: $message");
    }
    if (initResponse.paymentId == null) {
      Log.exception(Exception("initResponse.paymentId == null"), null, "PayRecurrentPaymentUseCaseImpl");
      return Result.failure("Не удалось создать платёж.");
    }

    ///Оповещаем бэкенд о том, что платёж создан
    final createPayResult =
        await _notifyPaymentWasCreatedUseCase.notify(paymentObject.orderId, initResponse.paymentId!, AcquiringType.tinkoff);
    if (!createPayResult.isSuccess) {
      return Result.failure(createPayResult.message);
    }

    ///Списываем деньги с рекуррентной карты
    final chargeResponse = await acquiring.charge(t.ChargeRequest(
      paymentId: int.parse(initResponse.paymentId!),
      rebillId: activeCardRebillId,
    ));
    if (chargeResponse.success != true) {
      final message = chargeResponse.details ?? chargeResponse.message ?? "Не удалось оплатить.";
      Log.exception(
        Exception("chargeResponse.success != true : $message"),
        null,
        "PayRecurrentPaymentUseCaseImpl",
      );
      return Result.failure(message);
    }

    ///Оповещаем бэкенд о том, что платёж прошёл успешно
    final finishPayResult = await _notifyPaymentWasPaidUseCase.notify(paymentObject.orderId);
    if (!finishPayResult.isSuccess) {
      return Result.failure(finishPayResult.message);
    }
    return Result.success("Ваш заказ успешно оплачен");
  }
}
