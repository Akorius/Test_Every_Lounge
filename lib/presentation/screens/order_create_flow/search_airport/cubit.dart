import 'dart:async';

import 'package:async/async.dart' hide Result;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/domain/usecases/lounge/search_airport.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class SearchAirportCubit extends Cubit<SearchAirportState> {
  final SearchAirportUseCase _searchAirportUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  SearchAirportCubit({required ServiceSearchType serviceType}) : super(SearchAirportState(serviceType: serviceType)) {
    getNearbyAirports();
    getPopularAirports();
    getHistoryAirports();
    _metricsUseCase.sendEvent(
        event: serviceType == ServiceSearchType.lounge
            ? eventName[businessLoungeServicesClick]!
            : eventName[meetAndAssistServicesClick]!,
        type: MetricsEventType.click);
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  CancelableOperation<Result<List<Airport>>>? operation;

  getSearchAirports({String? text}) async {
    operation?.cancel();
    emit(state.copyWith(isLoadingSearch: true, fromSearch: text != null));
    EasyDebounce.debounce(
      "searchAirports",
      const Duration(milliseconds: 500),
      () async {
        operation = CancelableOperation.fromFuture(_searchAirportUseCase.getSearch(text, state.serviceType));
        var result = await operation?.value;
        if (result != null) {
          if (result.isSuccess == true) {
            emit(state.copyWith(
              airportListSearch: result.value,
              isShowInfoWarning: result.value.isEmpty,
            ));
          } else {
            _messageController.add(result.message);
          }
        }

        emit(state.copyWith(isLoadingSearch: false));
      },
    );
  }

  getNearbyAirports() async {
    emit(state.copyWith(isLoadingNearby: true));
    operation = CancelableOperation.fromFuture(_searchAirportUseCase.getNearby(state.serviceType));
    var result = await operation?.value;
    if (result != null) {
      if (result.isSuccess == true) {
        emit(state.copyWith(
          airportListNearby: result.value,
          isShowInfoWarning: result.value.isEmpty,
        ));
      } else {
        _messageController.add(result.message);
      }
    }

    emit(state.copyWith(isLoadingNearby: false));
  }

  getHistoryAirports() async {
    emit(state.copyWith(isLoadingHistory: true));
    var result = await _searchAirportUseCase.getHistory(state.serviceType);
    if (result.isSuccess == true) {
      if (!isClosed) {
        emit(state.copyWith(
          airportListHistory: result.value,
          isShowInfoWarning: result.value.isEmpty,
        ));
      }
    } else {
      _messageController.add(result.message);
    }

    emit(state.copyWith(isLoadingHistory: false));
  }

  getPopularAirports() async {
    emit(state.copyWith(isLoadingPopular: true));
    var result = await _searchAirportUseCase.getPopular(state.serviceType);
    if (result.isSuccess == true) {
      emit(state.copyWith(
        airportListPopular: result.value,
        isShowInfoWarning: result.value.isEmpty,
      ));
    } else {
      _messageController.add(result.message);
    }

    emit(state.copyWith(isLoadingPopular: false));
  }

  onClearSearch() {
    emit(state.copyWith(isLoadingSearch: true, airportListSearch: [], fromSearch: false));
  }

  changeShowAlert(bool value) {
    emit(state.copyWith(isShowInfoWarning: value));
  }

  sendEventClick(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  @override
  Future<void> close() {
    operation?.cancel();
    EasyDebounce.cancel("searchAirports");
    return super.close();
  }
}
