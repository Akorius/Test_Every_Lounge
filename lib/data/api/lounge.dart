import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';

class LoungeApiImpl implements LoungeApi {
  final Dio _client = getIt();

  @override
  Future<Airport> getAirport(String airportCode) async {
    final response = await _client.get("airports/$airportCode");
    return Airport.fromJson(response.data["data"]);
  }

  @override
  Future<List<Airport>> getSearchAirport({
    String? search,
    ServiceSearchType? serviceType,
  }) async {
    final response = await _client.get(
      "airports",
      queryParameters: {
        if (search != null) "search": search,
        if (serviceType != null) "service_type": serviceType.index,
      },
    );
    final data = response.data["data"];
    final list = data.map((e) => Airport.fromJson(e)).toList();

    return List<Airport>.from(list);
  }

  @override
  Future<List<Airport>> getHistoryAirports({ServiceSearchType? serviceType}) async {
    final response = await _client.get(
      "airports/history",
      queryParameters: {
        if (serviceType != null) "service_type": serviceType.index,
      },
    );

    final list = response.data["data"].map((e) => Airport.fromJson(e)).toList();
    return List<Airport>.from(list);
  }

  @override
  Future<List<Airport>> getNearbyAirports({
    ServiceSearchType? serviceType,
    double? lan,
    double? lon,
  }) async {
    final response = await _client.get(
      "airports",
      queryParameters: {
        if (serviceType != null) "service_type": serviceType.index,
        if (lan != null) "lat": lan,
        if (lon != null) "lon": lon,
      },
    );

    final list = response.data["data"].map((e) => Airport.fromJson(e)).toList();
    return List<Airport>.from(list);
  }

  @override
  Future<List<Lounge>> getLounges(String airportCode) async {
    final response = await _client.get(
      "lounges/list",
      queryParameters: {'airport': airportCode, 'limit': '50', 'page': '1'},
    );

    final list = response.data["data"].map((e) => Lounge.fromJson(e)).toList();
    return List<Lounge>.from(list);
  }

  @override
  Future<bool> checkAAHealth(String loungeInternalId) async {
    final response = await _client.get("lounges/healthy/$loungeInternalId");

    return response.data["data"]["healthy"];
  }

  @override
  Future<List<Airport>> getPopularAirports({ServiceSearchType? serviceType}) async {
    final response = await _client.get(
      "airports",
      queryParameters: {
        if (serviceType != null) "service_type": serviceType.index,
      },
    );

    final list = response.data["meta"]["popular"].map((e) => Airport.fromJson(e)).toList();
    return List<Airport>.from(list);
  }
}
