import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

import 'set_active.dart';

abstract class AddBankByPhoneNumberUseCase {
  Future<Result> search({
    required String phone,
    required int type,
  });

  Future<Result> confirm({
    required String phone,
    required String code,
    required BankCardType bankType,
  });
}

class AddBankByPhoneNumberUseCaseImpl implements AddBankByPhoneNumberUseCase {
  final PrivilegesApi _privilegesApi = getIt();
  final SetActiveCardUseCase _setActiveCardUseCase = getIt();

  @override
  Future<Result> search({
    required String phone,
    required int type,
  }) async {
    try {
      await _privilegesApi.searchByPhone(phone, type);
    } catch (e, s) {
      late final String message;
      late final Failure failure;
      if (e is DioError && e.response?.statusCode == 404) {
        message = "По данному номеру пользователь не найден";
        failure = Failure.inputError;
      } else {
        message = "Не удалось отправить номер телефона.";
        failure = Failure.snackBar;
      }
      Log.exception(e, s, "AddBankByPhoneNumberUseCaseImpl");
      return Result.failure(message, failure);
    }
    return Result.success("");
  }

  @override
  Future<Result> confirm({
    required String phone,
    required String code,
    required BankCardType bankType,
  }) async {
    try {
      await _privilegesApi.confirmByPhone(phone, code, getIndexByActiveCard(bankType));
    } on DioError catch (e, s) {
      late final String message;
      if (e.response?.data["code"] == 404) {
        message = "Неправильный код";
      } else {
        message = "Не удалось отправить код.";
      }
      Log.exception(e, s, "AddBankByPhoneNumberUseCaseImpl");
      return Result.failure(message);
    } catch (e, s) {
      Log.exception(e, s, "AddBankByPhoneNumberUseCaseImpl");
      return Result.failure("Не удалось отправить код.");
    }

    final result = await _setActiveCardUseCase.set(cardType: bankType, sdkId: "");
    if (!result.isSuccess) {
      return Result.failure(result.message);
    }
    return Result.success("");
  }
}

enum Failure {
  snackBar,
  inputError,
}
