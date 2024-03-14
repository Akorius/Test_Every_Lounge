import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/order.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';
import 'package:everylounge/domain/entities/order/order_check_info.dart';
import 'package:everylounge/domain/entities/order/passengers.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';

abstract class CheckPassageUseCase {
  ///Проверяем на проходы
  Future<Result<PassageCheck>> checkPassage(Lounge lounge);
}

class CheckPassageUseCaseImplMock implements CheckPassageUseCase {
  final PassageCheck passageCheck;

  CheckPassageUseCaseImplMock({required this.passageCheck});

  @override
  Future<Result<PassageCheck>> checkPassage(Lounge lounge) async {
    return Result.success(passageCheck);
  }
}

class CheckPassageUseCaseImpl implements CheckPassageUseCase {
  final OrderApi _passageApi = getIt();
  final GetUserUseCase _getUserUseCase = getIt();

  @override
  Future<Result<PassageCheck>> checkPassage(Lounge lounge) async {
    final user = await _getUserUseCase.stream.first;

    if (lounge.id != 0) {
      PassageCheckInfo info = PassageCheckInfo(loungeId: lounge.id, passengers: [
        Passengers(
          firstName: user.activePassage?.firstName ?? '',
          lastName: user.activePassage?.lastName ?? '',
        ),
      ]);

      try {
        final PassageCheck data = await _passageApi.checkPassage(info);
        return Result.success(data);
      } catch (e, s) {
        Log.exception(e, s, "CheckPassageUseCaseImpl");
      }
    }
    return Result.failure("Не удалось проверить проходы.");
  }
}
