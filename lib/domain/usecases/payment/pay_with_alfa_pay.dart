import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_pay.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/payment/alfa_init_result.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_created.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_paid.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class PayWithAlfaPayUseCase {
  Future<Result<String>> pay(PaymentObject paymentObject);

  Future<Result<String>> fromAlfaBankReturned();
}

class PayWithAlfaPayUseCaseImpl implements PayWithAlfaPayUseCase {
  final AlfaPayApi _alfaPayApi = getIt();
  final NotifyPaymentWasCreatedUseCase _notifyPaymentWasCreatedUseCase = getIt();
  final NotifyPaymentWasPaidUseCase _notifyPaymentWasPaidUseCase = getIt();
  final MetricsUseCase _metrics = getIt();

  DateTime? lastAppLinkTime;
  StreamSubscription? _appLinkStream;
  PaymentObject? paymentObjectField;
  Uri? alfaPayUri;

  @override
  Future<Result<String>> pay(PaymentObject paymentObject) async {
    ///Получаем ссылку на оплату
    final createUriResult = await createUri(paymentObject);
    if (createUriResult.isSuccess) {
      paymentObjectField = paymentObject;
      alfaPayUri = createUriResult.value;
      if (PlatformWrap.isAndroidOrIOS) {
        launchUrl(
          createUriResult.value,
          mode: PlatformWrap.isIOS ? LaunchMode.externalApplication : LaunchMode.platformDefault,
        );
      }
    } else {
      return Result.failure("Ошибка оплаты AlfaPay");
    }

    ///Начинаем слушать входящую ссылку из приложения alfa об успешной оплате
    _appLinkStream = AppLinks().stringLinkStream.listen((event) {
      lastAppLinkTime = DateTime.now();
      _appLinkStream?.cancel();
    });

    return Result.success("");
  }

  Future<Result<Uri>> createUri(PaymentObject paymentObject) async {
    AlfaInitResult result;
    try {
      var id = int.parse(paymentObject.orderId);
      result = await _alfaPayApi.createUri(
        orderId: id,
      );

      //Оповещаем бэкенд о том, что платёж создан
      final createPayResult =
          await _notifyPaymentWasCreatedUseCase.notify(paymentObject.orderId, result.transactionId, AcquiringType.alfa);
      if (!createPayResult.isSuccess) {
        return Result.failure(createPayResult.message);
      }

      return Result.success(Uri.parse(result.redirect));
    } catch (e, s) {
      Log.exception(e, s, "createUri");
      return Result.failure("Ошибка оплаты AlfaPay");
    }
  }

  ///Продолжаем обрабатывать результат платежа после того, как наше приложение вошло в стадию resume
  @override
  Future<Result<String>> fromAlfaBankReturned() async {
    if (alfaPayUri == null) return Result.failure("isEmpty");
    await Future.delayed(ms(300));

    final latestAppLink = await AppLinks().getLatestAppLink();
    if (latestAppLink == null || lastAppLinkTime == null || lastAppLinkTime!.difference(DateTime.now()).inMilliseconds < -10000) {
      return handleFail("$latestAppLink $lastAppLinkTime ${lastAppLinkTime?.difference(DateTime.now()).inMilliseconds}");
    }
    if (latestAppLink.toString().contains(successUrl) &&
        (!latestAppLink.queryParameters.containsKey(transactionParam) ||
            latestAppLink.queryParameters.containsValue(alfaPayUri?.queryParameters[transactionParam]))) {
      return notifyPayment();
    } else {
      return handleFail(latestAppLink.toString());
    }
  }

  Result<String> handleFail(String latestAppLink) {
    alfaPayUri = null;
    paymentObjectField = null;
    return Result.failure(latestAppLink);
  }

  Result<String> notifyPayment() {
    ///Оповещаем бэкенд о том, что оплата свершилась
    _metrics.sendEvent(event: eventName[alfaPaySuccess]!, type: MetricsEventType.message);
    _notifyPaymentWasPaidUseCase.notify(paymentObjectField!.orderId);
    alfaPayUri = null;
    paymentObjectField = null;
    return Result.success("Ваш заказ успешно оплачен");
  }
}
