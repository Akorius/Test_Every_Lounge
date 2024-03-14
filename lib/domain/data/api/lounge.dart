import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';

abstract class LoungeApi {
  Future<Airport> getAirport(String airportCode);

  Future<List<Airport>> getSearchAirport({
    String? search,
    ServiceSearchType? serviceType,
  });

  Future<List<Airport>> getNearbyAirports({
    double? lan,
    double? lon,
    ServiceSearchType? serviceType,
  });

  Future<List<Airport>> getHistoryAirports({ServiceSearchType? serviceType});

  Future<List<Airport>> getPopularAirports({ServiceSearchType? serviceType});

  Future<List<Lounge>> getLounges(String airportCode);

  Future<bool> checkAAHealth(String loungeInternalId);
}
