import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/lounge.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/domain/usecases/lounge/get_position.dart';

abstract class SearchAirportUseCase {
  Future<Result<List<Airport>>> getSearch(String? searchText, ServiceSearchType? serviceType);

  Future<Result<List<Airport>>> getNearby(ServiceSearchType? serviceType);

  Future<Result<List<Airport>>> getHistory(ServiceSearchType? serviceType);

  Future<Result<List<Airport>>> getPopular(ServiceSearchType? serviceType);
}

class SearchAirportUseCaseImpl implements SearchAirportUseCase {
  final LoungeApi _loungeApi = getIt();
  final GetPositionUseCase _getPositionUseCase = getIt();

  ///Получаем список поиска аэропортов
  @override
  Future<Result<List<Airport>>> getSearch(String? searchText, ServiceSearchType? serviceType) async {
    late final List<Airport> airports;
    try {
      airports = await _loungeApi.getSearchAirport(search: searchText, serviceType: serviceType);
    } catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure("Не удалось найти аэропорт");
    }
    return Result.success(airports);
  }

  ///Получаем список аэропортов по поиску и по местоположению
  @override
  Future<Result<List<Airport>>> getNearby(ServiceSearchType? serviceType) async {
    late final List<Airport> airports;
    try {
      final position = await _getPositionUseCase.get();
      if (position.isSuccess) {
        airports = await _loungeApi.getNearbyAirports(
            lan: position.value.latitude, lon: position.value.longitude, serviceType: serviceType);
      } else {
        airports = await _loungeApi.getNearbyAirports(serviceType: serviceType);
      }
    } catch (e, s) {
      Log.exception(e, s, "search");
      return Result.failure("Не удалось найти аэропорт");
    }
    return Result.success(airports);
  }

  ///Получаем список истории аэропортов
  @override
  Future<Result<List<Airport>>> getHistory(ServiceSearchType? serviceType) async {
    late final List<Airport> airports;
    try {
      airports = await _loungeApi.getHistoryAirports(serviceType: serviceType);
    } catch (e, s) {
      Log.exception(e, s, "history");
      return Result.failure("Не удалось загрузить историю аэропортов");
    }
    return Result.success(airports);
  }

  ///Получаем список популярных аэропортов
  @override
  Future<Result<List<Airport>>> getPopular(ServiceSearchType? serviceType) async {
    late final List<Airport> airports;
    try {
      airports = await _loungeApi.getPopularAirports(serviceType: serviceType);
    } catch (e, s) {
      Log.exception(e, s, "popular");
      return Result.failure("Не удалось загрузить популярные аэропорты");
    }
    return Result.success(airports);
  }
}
