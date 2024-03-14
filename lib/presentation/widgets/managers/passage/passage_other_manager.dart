import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';

class PassageOtherManager extends PassageManager {
  @override
  bool get isPassageOver {
    if (activeBankCard?.cardForPaymentByPasses == true) {
      return activeBankCard?.passesCount == 0;
    }
    return false;
  }

  @override
  bool isPassLimitEnable({bool isFullPassengersCount = false}) => simplePassesLimitEnable;

  bool get simplePassesLimitEnable {
    return activeBankCard?.cardForPaymentByPasses == true &&
        activeBankCard?.passesCount != -1 &&
        (activeBankCard?.passesCount ?? 0) < passengersCount;
  }

  @override
  int getMaxCountPasses({bool withCheckPassageOver = false}) {
    var cardPassesCount = activeBankCard?.passesCount ?? 0;
    switch (activeBankCard?.type) {
      case BankCardType.tochka:
      case BankCardType.beelineKZ:

        /// если проходы закончились (==0) то вернуть maxPassengers, потому что будет оплата онлайн
        if (cardPassesCount > 0) {
          return cardPassesCount > maxPassengers ? maxPassengers : cardPassesCount - 1;
        } else {
          return maxPassengers;
        }
      default:
        return maxPassengers;
    }
  }

  @override
  Future<void> checkPassage(Lounge lounge) async {
    return;
  }

  @override
  bool get needShowAttention => false;
}
