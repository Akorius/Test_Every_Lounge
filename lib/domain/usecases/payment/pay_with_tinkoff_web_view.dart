import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/localization.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';

import 'init_pay.dart';
import 'notify_payment_was_created.dart';
import 'notify_payment_was_paid.dart';

abstract class PayWithTinkoffWebView {
  Future<Result<Uri>> createUri(PaymentObject paymentObject);

  processFromWebViewReturnedSuccess();
}

class PayWithTinkoffWebViewImpl implements PayWithTinkoffWebView {
  final InitAcquiringUseCase _initAcquiringUseCase = getIt();
  final InitPayUseCase _initPayUseCase = getIt();
  final NotifyPaymentWasCreatedUseCase _notifyPaymentWasCreatedUseCase = getIt();
  final NotifyPaymentWasPaidUseCase _notifyPaymentWasPaidUseCase = getIt();
  final DeveloperModeStorage _developerModeStorage = getIt();

  String orderId = "";

  @override
  Future<Result<Uri>> createUri(PaymentObject paymentObject) async {
    ///Инициализируем эквайринг нужными кредами
    final acquiringResult = await _initAcquiringUseCase.init(
      shop: paymentObject.isAirportForeign ? ClientShop.tinkoffForeign : ClientShop.tinkoffRu,
    );
    if (!acquiringResult.isSuccess) {
      return Result.failure(acquiringResult.message);
    }
    final acquiring = acquiringResult.value;

    ///Инициализируем платёж
    //
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
      Log.exception(Exception("Не удалось создать платёж: $message"), null, "PayWithTinkoffWebViewImpl");
      return Result.failure("Не удалось создать платёж: $message");
    }
    if (initResponse.paymentId == null) {
      Log.exception(Exception("initResponse.paymentId == null"), null, "PayWithTinkoffWebViewImpl");
      return Result.failure("Не удалось создать платёж.");
    }
    orderId = paymentObject.orderId;

    late final Uri uri;
    try {
      uri = Uri.parse(initResponse.paymentURL!);
    } catch (e, s) {
      Log.exception(e, s, "PayWithTinkoffWebViewImpl");
      return Result.failure("Не удалось создать Url оплаты.");
    }

    ///Оповещаем бэкенд о том, что платёж создан
    final createPayResult =
        await _notifyPaymentWasCreatedUseCase.notify(paymentObject.orderId, initResponse.paymentId!, AcquiringType.tinkoff);
    if (!createPayResult.isSuccess) {
      return Result.failure(createPayResult.message);
    }

    return Result.success(uri);
  }

  @override
  processFromWebViewReturnedSuccess() {
    _notifyPaymentWasPaidUseCase.notify(orderId);
  }
}
