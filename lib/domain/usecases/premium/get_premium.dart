import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/premium.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';

abstract class GetPremiumServicesUseCase {
  ///Получаем список премиум услуг по коду аэропорта
  Future<Result<List<PremiumService>>> get(String airportCode);
}

class GetPremiumServicesUseCaseImpl implements GetPremiumServicesUseCase {
  final PremiumServicesApi _premiumServiceApi = getIt();

  @override
  Future<Result<List<PremiumService>>> get(String airportCode) async {
    try {
      final List<PremiumService> lounges = await _premiumServiceApi.getServicesList(airportCode);
      return Result.success(lounges);
    } catch (e, s) {
      Log.exception(e, s, "get");
      return Result.failure("Не удалось получить список бизнес-залов");
    }
  }
}
