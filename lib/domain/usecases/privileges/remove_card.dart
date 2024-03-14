import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/privileges.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class RemoveCardUseCase {
  Future<Result<bool>> call({required int sdkCardId});
}

class RemoveCardUseCaseImpl implements RemoveCardUseCase {
  final PrivilegesApi _cardApi = getIt();

  RemoveCardUseCaseImpl();

  @override
  Future<Result<bool>> call({required int sdkCardId}) async {
    try {
      await _cardApi.removeCard(sdkCardId: sdkCardId);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "RemoveCardUseCaseImpl");
      return Result.failure("Не удалось отвязать карту");
    }
  }
}
