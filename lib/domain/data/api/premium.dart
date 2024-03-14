import 'package:everylounge/domain/entities/premium/premium_services.dart';

abstract class PremiumServicesApi {
  Future<List<PremiumService>> getServicesList(String airportCode);
}
