import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';

abstract class SetActiveCardUseCase {
  Future<Result<bool>> set({
    required BankCardType cardType,
    required String sdkId,
  });
}

class SetActiveCardUseCaseImpl implements SetActiveCardUseCase {
  final PrivilegesApi _cardApi = getIt();
  final MetricsUseCase _metricsUseCase = getIt();

  @override
  Future<Result<bool>> set({
    required BankCardType cardType,
    required String sdkId,
  }) async {
    try {
      switch (cardType) {
        case BankCardType.other:
        case BankCardType.otkrytie:
        case BankCardType.moscowCredit:
        case BankCardType.gazpromDefault:
        case BankCardType.gazpromPremium:
        case BankCardType.gazpromPrivate:
          await _cardApi.setCardActive(sdkId);
          break;
        case BankCardType.raiffeisen:
          break;
        case BankCardType.alfaPrem:
        case BankCardType.alfaClub:
          await _cardApi.setBankActive(ActiveBank.alfa.index);
          break;
        case BankCardType.tochka:
          await _cardApi.setBankActive(ActiveBank.tochka.index);
          break;
        case BankCardType.beelineKZ:
          await _cardApi.setBankActive(ActiveBank.beelineKZ.index);
          break;
        case BankCardType.tinkoffDefault:
        case BankCardType.tinkoffPremium:
        case BankCardType.tinkoffPrivate:
        case BankCardType.tinkoffPro:
          await _cardApi.setBankActive(ActiveBank.tinkoff.index);
          break;
      }
      _metricsUseCase.sendEvent(event: "${eventName[setCard]}: ${cardType.name}", type: MetricsEventType.message);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "SetActiveCardUseCaseImpl");
      return Result.failure("Не удалось изменить активную карту");
    }
  }
}
