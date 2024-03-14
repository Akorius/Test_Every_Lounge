import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class CheckAAHealthUseCase {
  Future<Result<bool>> check(String loungeInternalId);
}

class CheckAAHealthUseCaseImplMock implements CheckAAHealthUseCase {
  @override
  Future<Result<bool>> check(String loungeInternalId) async {
    return Result.success(true);
  }
}

class CheckAAHealthUseCaseImpl implements CheckAAHealthUseCase {
  final LoungeApi _loungeApi = getIt();

  @override
  Future<Result<bool>> check(String loungeInternalId) async {
    late final bool available;
    try {
      available = await _loungeApi.checkAAHealth(loungeInternalId);
    } catch (e, s) {
      Log.exception(e, s, "GetAirportUseCaseImpl");
      return Result.failure("Не удалось проверить доступность бронирования зала. Попробуйте позднее.");
    }
    return Result.success(available);
  }
}
