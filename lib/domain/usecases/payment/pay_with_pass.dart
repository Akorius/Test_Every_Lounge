import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/payment/payment_object.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:everylounge/domain/usecases/user/update_tinkoff_user.dart';

abstract class PayWithPassUseCase {
  Future<Result<String>> pay(PaymentObject paymentObject, {bool isTinkoff = false});
}

class PayWithPassUseCaseImplMock implements PayWithPassUseCase {
  @override
  Future<Result<String>> pay(PaymentObject paymentObject, {bool isTinkoff = false}) async {
    return Result.success('');
  }
}

class PayWithPassUseCaseImpl implements PayWithPassUseCase {
  final OrderApi _orderApi = getIt();
  final GetCardsUseCase _getUserUseCase = getIt();
  final TokensStorage _tokensStorage = getIt();
  final TinkoffPassUseCase _tinkoffPassUseCase = getIt();
  final UpdateTinkoffUserUseCase _updateTinkoffUserUseCaseImpl = getIt();

  @override
  Future<Result<String>> pay(PaymentObject paymentObject, {bool isTinkoff = false}) async {
    if (isTinkoff == true) {
      try {
        await _updateTinkoffUserUseCaseImpl.update();
      } catch (e, s) {
        Log.exception(e, s, "PayWithPassUseCase");
        return Result.failure("Не удалось обновить тинькофф пользователя.");
      }
    }

    ///Оплачиваем заказ проходом
    try {
      final response = await _orderApi.payOrderByPassage(paymentObject.orderId,
          tinkoffToken: isTinkoff ? _tokensStorage.tinkoffAccessToken : null);
      if (response) {
        ///Обновляем список карт, а заодно и пользователя, чтобы обновилось количество проходов
        if (isTinkoff) {
          _tinkoffPassUseCase.getPassageInfo(_tokensStorage.tinkoffAccessToken ?? '').then((value) => _getUserUseCase.get());
        } else {
          _getUserUseCase.get();
        }
        return Result.success("Ваш заказ успешно оформлен");
      } else {
        return Result.failure("Не удалось списать проходы.");
      }
    } catch (e, s) {
      Log.exception(e, s, "PayWithPassUseCase");
      return Result.failure("Не удалось списать проходы.");
    }
  }
}
