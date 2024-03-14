import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';

abstract class GetLoungesUseCase {
  ///Получаем список бизнес-залов по коду аэропорта
  Future<Result<List<Lounge>>> get(String airportCode);
}

class GetLoungesUseCaseImpl implements GetLoungesUseCase {
  final LoungeApi _loungeApi = getIt();

  @override
  Future<Result<List<Lounge>>> get(String airportCode) async {
    ///Получаем список бизнес-залов по коду аэропорта
    late final List<Lounge> lounges;
    try {
      lounges = await _loungeApi.getLounges(airportCode.toUpperCase());
    } catch (e, s) {
      Log.exception(e, s, "get");
      return Result.failure("Не удалось получить список бизнес-залов");
    }
    return Result.success(lounges);
  }
}
