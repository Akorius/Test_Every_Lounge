import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/usecases/order/check_passage.dart';
import 'package:everylounge/presentation/widgets/managers/passage/passage_manager.dart';

class PassageAlfaManager extends PassageManager {
  final CheckPassageUseCase checkPassageUseCase;

  PassageAlfaManager({required this.checkPassageUseCase});

  @override
  checkPassage(Lounge lounge) async {
    final result = await checkPassageUseCase.checkPassage(lounge);
    passageCheck = result.isSuccess ? result.value : null;
  }

  @override
  bool get isPassageOver {
    if (activeBankCard?.passesCount == -1) {
      return !(passageCheck?.passagePayAvailable ?? false);
    } else {
      return activeBankCard?.passesCount == 0;
    }
  }

  @override
  bool isPassLimitEnable({bool isFullPassengersCount = false}) => alfaLimitEnable(isFullPassengersCount: isFullPassengersCount);

  ///срабатывает когда на счетчике количество гостей + 1 пользователь
  ///достигает количества проходов, полученных от бэка для этого бизнес-зала
  ///в параметре passengersAvailableCount
  bool alfaLimitEnable({bool isFullPassengersCount = false}) {
    return (activeBankCard?.passesCount != -1 && (activeBankCard?.passesCount ?? 0) < passengersCount) ||
        (activeBankCard?.passesCount == -1 &&
            passageCheck != null &&
            passageCheck!.passagePayAvailable &&
            passageCheck!.passengersAvailableCount < passengersCount + (isFullPassengersCount ? 0 : 1) &&
            maxPassengers != passengersCount - 1);
  }

  @override
  bool get needShowAttention => activeBankCard?.passesCount == 0 || alfaLimitEnable();

  @override
  int getMaxCountPasses({bool withCheckPassageOver = false}) {
    var cardPassesCount = activeBankCard?.passesCount ?? 0;
    if (passageCheck != null && passageCheck?.passagePayAvailable == true) {
      int passes;
      if (cardPassesCount == -1 || (passageCheck!.passengersAvailableCount < cardPassesCount)) {
        passes = (passageCheck!.passengersAvailableCount - 1);
      } else {
        passes = cardPassesCount - 1;
      }
      return (passes > maxPassengers) ? maxPassengers : passes;
    } else {
      return maxPassengers;
    }
  }
}
