import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/passage.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';

abstract class RemovePassageUseCase {
  Future<Result<bool>> call({required int id});
}

class RemovePassageUseCaseImpl implements RemovePassageUseCase {
  final PassageApi _passageApi = getIt();

  RemovePassageUseCaseImpl();

  @override
  Future<Result<bool>> call({required int id}) async {
    try {
      await _passageApi.removePassage(id: id);
      return Result.success(true);
    } catch (e, s) {
      Log.exception(e, s, "RemovePassageUseCaseImpl");
      return Result.failure("Не удалось отвязать проход");
    }
  }
}
