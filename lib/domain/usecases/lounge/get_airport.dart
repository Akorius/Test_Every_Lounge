import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';

abstract class GetAirportUseCase {
  ///Получаем аэропорт с бэкенда
  Future<Result<Airport>> get(String airportCode);
}

class GetAirportUseCaseImpl implements GetAirportUseCase {
  final LoungeApi _loungeApi = getIt();

  @override
  Future<Result<Airport>> get(String airportCode) async {
    ///Получаем аэропорт с бэкенда
    late final Airport airport;
    try {
      airport = await _loungeApi.getAirport(airportCode.toUpperCase());
    } catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure("Не удалось получить аэропорт.");
    }
    return Result.success(airport);
  }
}
