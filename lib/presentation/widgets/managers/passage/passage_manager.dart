import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';

abstract class PassageManager {
  Future<void> checkPassage(Lounge lounge);

  ///переключает на онлайн оплату
  ///максимальное количество пользователей == maxPassengers
  ///уведомление для альфы и тинькова при старте
  ///не дизейблется кнопка оплаты
  ///не выводятся уведомления для альфы и тинькова при достижении maxPassengers
  bool get isPassageOver;

  bool get needShowAttention;

  bool isPassLimitEnable({bool isFullPassengersCount = false});

  BankCard? activeBankCard;
  PassageCheck? passageCheck;
  int passengersCount = 0;
  int? tinkoffPassageCount;
  final int maxPassengers = 7;

  ///отображение ошибки о достижении максимального количества гостей
  ///для проходов которые не безлимит
  bool get isRichedMaxGuests {
    var passesCount = activeBankCard?.passesCount ?? 0;
    if (passesCount != -1 && passesCount != 0) {
      return passesCount == passengersCount && passesCount != maxPassengers + 1;
    } else {
      return false;
    }
  }

  ///Проверка возможности оплаты -
  ///бесконечные проходы,
  ///обычных проходов больше чем пассажиров,
  bool get passesMoreThenPassengers {
    var passengers = passengersCount - 1;
    final limitedPassesMoreThenPassengers = activeBankCard?.cardForPaymentByPasses == true &&
        activeBankCard?.passesCount != -1 &&
        passengers < (activeBankCard?.passesCount ?? 0);
    final endlessPass = activeBankCard?.passesCount == -1;
    return activeBankCard?.cardForPaymentByPasses == false || limitedPassesMoreThenPassengers || endlessPass;
  }

  int getMaxCountPasses({bool withCheckPassageOver = false});

  ///блокирует счетчик "plus"
  bool get needDisableAdditionPassengers => passengersCount > getMaxCountPasses();
}
