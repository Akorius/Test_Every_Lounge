import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/usecases/user/tinkoff_pass.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';

class PassageTinkoffManager extends PassageManager {
  final TinkoffPassUseCase tinkoffPassUseCase;

  PassageTinkoffManager({required this.tinkoffPassUseCase});

  @override
  checkPassage(Lounge lounge) async {
    tinkoffPassageCount = tinkoffPassUseCase.passage?.counterInfo?.count;
  }

  @override
  bool get isPassageOver {
    if (activeBankCard?.type == BankCardType.tinkoffPrivate || activeBankCard?.type == BankCardType.tinkoffPremium) {
      return tinkoffPassageCount == 0;
    } else if (activeBankCard?.cardForPaymentByPasses == true) {
      return activeBankCard?.passesCount == 0;
    }
    return false;
  }

  @override
  bool isPassLimitEnable({bool isFullPassengersCount = false}) =>
      tinkoffLimitEnable(isFullPassengersCount: isFullPassengersCount);

  ///срабатывает когда на счетчике количество гостей + 1 пользователь
  ///достигает количества проходов, полученых от тинька для этого пользователя
  bool tinkoffLimitEnable({bool isFullPassengersCount = false}) {
    return (activeBankCard?.type == BankCardType.tinkoffPrivate || activeBankCard?.type == BankCardType.tinkoffPremium) &&
        tinkoffPassageCount != null &&
        tinkoffPassageCount! < passengersCount + (isFullPassengersCount ? 0 : 1);
  }

  @override
  bool get needShowAttention =>
      activeBankCard?.type == BankCardType.tinkoffPrivate &&
      passengersCount > getMaxCountPasses(withCheckPassageOver: true) &&
      (tinkoffPassageCount ?? 0) <= maxPassengers;

  @override
  int getMaxCountPasses({bool withCheckPassageOver = false}) {
    switch (activeBankCard?.type) {
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPremium:
        {
          return tinkoffPassageCount == null ||
                  (tinkoffPassageCount ?? 0) > maxPassengers ||
                  (withCheckPassageOver ? false : isPassageOver)
              ? maxPassengers
              : (tinkoffPassageCount! - 1);
        }
      default:
        return maxPassengers;
    }
  }

  ///тиньков безлимит и пассажиров-1 меньше чем проходов, полученных от тинькова,
  ///тиньков обычные проходы из карты больше чем пассажиров-1
  @override
  bool get passesMoreThenPassengers {
    var passengers = passengersCount - 1;
    final tinkoffCheck = activeBankCard?.availableTinkoffPasses == true &&
        ((activeBankCard?.passesCount == -1 && (passengers < (tinkoffPassageCount ?? 0))) ||
            passengers < (activeBankCard?.passesCount ?? 0));
    return activeBankCard?.cardForPaymentByPasses == false || tinkoffCheck;
  }
}
