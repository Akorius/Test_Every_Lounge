import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/localization.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart' as e;
import 'package:tinkoff_acquiring/tinkoff_acquiring.dart';

abstract class InitPayUseCase {
  Result<InitRequest> init({
    required e.PaymentObject paymentObject,
    required bool payWithOneRuble,
    required Localization localization,
  });
}

class InitPayUseCaseImpl implements InitPayUseCase {
  final UserStorage _userStorage = getIt();

  @override
  Result<InitRequest> init({
    required e.PaymentObject paymentObject,
    required bool payWithOneRuble,
    required Localization localization,
  }) {
    ///Получаем email и телефон пользователя из хранилищща

    final email = _userStorage.email;
    final phone = _userStorage.phone;

    if (!(email.isNotEmpty || phone != null)) {
      const message = "Не удалось проинициализировать платёж. Нет email и нет телефона пользователя.";
      Log.exception(Exception(message), null, "InitPayUseCase");
      return Result.failure("Не удалось проинициализировать платёж. Нет email и нет телефона пользователя.");
    }

    late final Language language;
    switch (localization) {
      case Localization.en:
        language = Language.en;
        break;
      case Localization.ru:
        language = Language.ru;
        break;
    }
    late final Receipt receipt;

    switch (paymentObject.orderType) {
      case OrderType.upgrade:
        receipt = Receipt.ffd105(
          email: email.isNotEmpty ? email : null,
          phone: email.isEmpty ? phone : null,
          taxation: Taxation.usnIncomeOutcome,
          items: [
            Items.ffd105(
              tax: Tax.none,
              paymentMethod: PaymentMethod.fullPayment,
              paymentObject: PaymentObject.service,
              price: payWithOneRuble ? 100 : paymentObject.pricePerOnePenny,
              name: paymentObject.serviceName,
              quantity: paymentObject.quantity.toInt(),
              amount: payWithOneRuble ? 100 : paymentObject.fullAmountPenny,
            )
          ],
        );
        break;
      case OrderType.lounge:
      case OrderType.premium:
      default:
        receipt = Receipt.ffd105(
          email: email.isNotEmpty ? email : null,
          phone: email.isEmpty ? phone : null,
          taxation: Taxation.usnIncomeOutcome,
          items: [
            Items.ffd105(
              tax: Tax.none,
              paymentMethod: PaymentMethod.fullPayment,
              paymentObject: PaymentObject.service,

              ///Цена за единицу
              price: payWithOneRuble ? 100 : paymentObject.pricePerOnePenny,
              name: paymentObject.serviceName,
              quantity: paymentObject.quantity.toInt(),

              /// Общая стоимость
              amount: payWithOneRuble ? 100 : paymentObject.fullAmountPenny,
              agentData: AgentData(agentSign: AgentSign.commissionAgent),
              supplierInfo: SupplierInfo(
                const ["+74957974227"],
                "ЗАО «АГЕНТ.РУ»",
                "7714628724",
              ),
            )
          ],
        );
        break;
    }

    return Result.success(InitRequest(
      description: paymentObject.serviceName,
      receipt: receipt,
      orderId: paymentObject.aaServiceId ?? paymentObject.orderId,
      customerKey: _userStorage.id.toString(),
      amount: payWithOneRuble ? 100 : paymentObject.fullAmountPenny,
      language: language,
      payType: PayType.one,
    ));
  }
}
