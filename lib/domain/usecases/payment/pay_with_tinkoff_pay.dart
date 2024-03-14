import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/entities/shops.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/payment/init_acquiring.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_created.dart';
import 'package:everylounge/domain/usecases/payment/notify_payment_was_paid.dart';
import 'package:flutter/services.dart';
import 'package:tinkoff_acquiring_native_flutter/tinkoff_acquiring_native_flutter.dart';
import 'package:tinkoff_id_flutter/tinkoff_id_flutter.dart';

abstract class PayWithTinkoffPayUseCase {
  ///Оплачиваем заказ
  ///Оповещаем бэкенд, что заказ оплачен
  Future<Result> pay(PaymentObject paymentObject);

  Future<Result<String>> fromTinkoffBankReturned();
}

class PayWithTinkoffPayUseCaseImpl implements PayWithTinkoffPayUseCase {
  final TinkoffAcquiring _tinkoffAcquiring = getIt();
  final TinkoffIdFlutter _tinkoffIdFlutter = getIt();
  final UserStorage _userStorage = getIt();
  final NotifyPaymentWasCreatedUseCase _notifyPaymentWasCreatedUseCase = getIt();
  final NotifyPaymentWasPaidUseCase _notifyPaymentWasPaidUseCase = getIt();
  final DeveloperModeStorage _developerModeStorage = getIt();
  final InitAcquiringUseCase _initAcquiringUseCase = getIt();
  final MetricsUseCase _metrics = getIt();
  final RemoteConfigStorage remoteConfigStorage = getIt();

  ///[0] - transactionId, [1] - deeplink
  List payWithTinkoffPayResult = [];

  DateTime? lastAppLinkTime;
  StreamSubscription? _appLinkStream;
  PaymentObject? paymentObjectField;

  @override
  Future<Result> pay(PaymentObject paymentObject) async {
    final bool isAvailable = await _tinkoffIdFlutter.isTinkoffAuthAvailable();
    if (!isAvailable && !PlatformWrap.isIOS) {
      return Result.failure("Приложение TinkoffBank не найдено или не установлено");
    }

    paymentObjectField = paymentObject;

    ///Выбираем магазин в котором будет производиться оплата в зависимости от иностранности аэропорта
    ///Инициализируем эквайринг Тинькофф
    final initAcquiringResult = await _initAcquiringUseCase.initNative(
      shop: paymentObject.isAirportForeign ? ClientShop.tinkoffForeign : ClientShop.tinkoffRu,
    );
    if (!initAcquiringResult.isSuccess) {
      return Result.failure(initAcquiringResult.message);
    }

    ///Проверяем доступность тинькофф пей на данном платёжном терминале
    late List result;
    late final bool available;
    late final String tinkoffPayVersion;
    try {
      result = await _tinkoffAcquiring.isTinkoffPayAvailable();
      available = result[0];
      // if (!available) throw Exception("available == false");
      if (!available) {
        if (PlatformWrap.isAndroid) {
          tinkoffPayVersion = '2.0';
        } else {
          throw Exception("available == false");
        }
      } else {
        tinkoffPayVersion = result[1];
      }
    } catch (e, s) {
      Log.exception(e, s, "PayWithTinkoffPayUseCaseImpl");
      return Result.failure("Tinkoff Pay не доступен на данном платёжном терминале.");
    }

    ///Проверяем наличие email у пользователя
    late final userEmail = _userStorage.email;
    if (userEmail.isEmpty) {
      const message = "Не предоставлен email для совершения платежа.";
      Log.exception(Exception(message), null, "PayWithTinkoffPayUseCaseImpl");
      return Result.failure(message);
    }

    ///Создаём платёж в терминале средствами SDK
    try {
      payWithTinkoffPayResult = await _tinkoffAcquiring.payWithTinkoffPay(
          orderId: paymentObject.aaServiceId ?? paymentObject.orderId,
          description: paymentObject.serviceName,
          amountKopek: _developerModeStorage.payWithOneRuble ? 100 : paymentObject.fullAmountPenny,
          itemName: paymentObject.serviceName,
          priceKopek: _developerModeStorage.payWithOneRuble ? 100 : paymentObject.pricePerOnePenny,
          tax: Tax.NONE,
          quantity: paymentObject.quantity,
          customerEmail: userEmail,
          taxation: Taxation.USN_INCOME_OUTCOME,
          customerKey: _userStorage.id.toString() ?? "",
          tinkoffPayVersion: tinkoffPayVersion,
          terminalKey: (initAcquiringResult.value as AcquiringKeyData).terminalKey,
          publicKey: (initAcquiringResult.value as AcquiringKeyData).publicKey,
          successUrl: successUrl,
          failUrl: failUrl);
    } on PlatformException catch (e, s) {
      Log.exception(e, s, "payWithTinkoff");
      return Result.failure("Ошибка платёжного терминала: ${e.message}");
    }

    ///Оповещаем бэкенд о том, что платёж был создан
    final notifyResult = await _notifyPaymentWasCreatedUseCase.notify(
      paymentObject.orderId,
      payWithTinkoffPayResult[0].toString(),
      AcquiringType.tinkoff,
    );
    if (!notifyResult.isSuccess) {
      return Result.failure(notifyResult.message);
    }

    ///Начинаем слушать входящую ссылку из приложения тинькофф об успешной оплате
    _appLinkStream = AppLinks().stringLinkStream.listen((event) {
      lastAppLinkTime = DateTime.now();
      _appLinkStream?.cancel();
    });

    ///Запускаем приложение Тинькофф Банка
    var launchResult = await _tinkoffAcquiring.launchTinkoffApp(payWithTinkoffPayResult[1], isAvailable);
    if (launchResult is PlatformException) {
      return Result.failure("Приложение TinkoffBank не найдено или не установлено");
    } else {
      return Result.success("");
    }
  }

  ///Продолжаем обрабатывать результат платежа после того, как наше приложение вошло в стадию resume
  @override
  Future<Result<String>> fromTinkoffBankReturned() async {
    if (payWithTinkoffPayResult.isEmpty) return Result.failure("isEmpty");
    await Future.delayed(ms(300));

    final latestAppLink = await AppLinks().getLatestAppLink();
    if (latestAppLink == null || lastAppLinkTime == null || lastAppLinkTime!.difference(DateTime.now()).inMilliseconds < -10000) {
      return handleFail("$latestAppLink $lastAppLinkTime ${lastAppLinkTime?.difference(DateTime.now()).inMilliseconds}");
    }
    if ((latestAppLink.toString().contains(successUrl) || latestAppLink.toString().contains(tinkoffSuccessUrl)) &&
        (!latestAppLink.queryParameters.containsKey(transactionParam) ||
            latestAppLink.queryParameters.containsValue(payWithTinkoffPayResult[0]))) {
      return notifyPayment();
    } else {
      return handleFail(latestAppLink.toString());
    }
  }

  Result<String> handleFail(String latestAppLink) {
    payWithTinkoffPayResult = [];
    paymentObjectField = null;
    return Result.failure(latestAppLink);
  }

  Result<String> notifyPayment() {
    ///Оповещаем бэкенд о том, что оплата свершилась
    _metrics.sendEvent(event: eventName[tinkoffPaySuccess]!, type: MetricsEventType.message);
    _notifyPaymentWasPaidUseCase.notify(paymentObjectField!.orderId);
    payWithTinkoffPayResult = [];
    paymentObjectField = null;
    return Result.success("Ваш заказ успешно оплачен");
  }
}
