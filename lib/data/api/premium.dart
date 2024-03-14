import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/premium.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';

class PremiumServicesApiImpl implements PremiumServicesApi {
  final Dio _client = getIt();

  @override
  Future<List<PremiumService>> getServicesList(String airportCode) async {
    final response = await _client.get(
      "premium/list",
      queryParameters: {'airport': airportCode, 'limit': '50', 'page': '1'},
    );
    final list = response.data["data"].map((e) => PremiumService.fromJson(e)).toList();
    return List<PremiumService>.from(list);
  }
}
