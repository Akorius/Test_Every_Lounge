import 'dart:async';

import 'package:async/async.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/update_user.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/rating/rating_flag.dart';
import 'package:rxdart/rxdart.dart';

abstract class CheckRateUseCase {
  Stream<bool> get checkRateStream;

  checkNeedShowRate();

  updateRateFlag(RateFlag? rateFlag);
}

class CheckRateUseCaseImpl implements CheckRateUseCase {
  final GetUserUseCase _getUserUseCase = getIt();
  final UpdateUserUseCase _updateUserUseCase = getIt();

  @override
  Stream<bool> get checkRateStream => _checkRateStreamController.stream;

  final _checkRateStreamController = BehaviorSubject<bool>();

  _needShowRate(int showRate) {
    final rateFlag = RateFlag.values[showRate];
    return rateFlag == RateFlag.showFirst || rateFlag == RateFlag.showSecond || rateFlag == RateFlag.showLast;
  }

  @override
  checkNeedShowRate() async {
    final user = await _getUserUseCase.stream.firstOrNull;
    if (user != null) {
      if (_needShowRate(user.showRate)) {
        _checkRateStreamController.add(true);
      }
    }
  }

  @override
  updateRateFlag(RateFlag? rateFlag) async {
    final rate = rateFlag ?? await _getUserUseCase.stream.firstOrNull.then((value) => RateFlag.values[value?.showRate ?? 0]);
    final result = await _updateUserUseCase.update(rateFlag: handleFlagByType(rate));
    Future.delayed(const Duration(seconds: 1), () {
      if (result.isSuccess) {
        _getUserUseCase.get();
      }
    });
  }
}
