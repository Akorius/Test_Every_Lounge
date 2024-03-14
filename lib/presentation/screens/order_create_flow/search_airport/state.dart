import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';

class SearchAirportState extends Equatable {
  final List<Airport> airportListNearby;
  final List<Airport> airportListHistory;
  final List<Airport> airportListPopular;
  final List<Airport> airportListSearch;
  final bool isLoadingNearby;
  final bool isLoadingHistory;
  final bool isLoadingPopular;
  final bool isLoadingSearch;
  final bool isShowInfoWarning;
  final bool fromSearch;
  final ServiceSearchType serviceType;

  const SearchAirportState({
    this.airportListNearby = const [],
    this.airportListHistory = const [],
    this.airportListPopular = const [],
    this.airportListSearch = const [],
    this.isLoadingNearby = true,
    this.isLoadingHistory = true,
    this.isLoadingPopular = true,
    this.isLoadingSearch = true,
    this.isShowInfoWarning = false,
    this.fromSearch = false,
    required this.serviceType,
  });

  @override
  List<Object?> get props => [
        airportListNearby,
        airportListHistory,
        airportListPopular,
        airportListSearch,
        isLoadingNearby,
        isLoadingHistory,
        isLoadingPopular,
        isLoadingSearch,
        isShowInfoWarning,
        fromSearch,
        serviceType,
      ];

  SearchAirportState copyWith({
    List<Airport>? airportListNearby,
    List<Airport>? airportListHistory,
    List<Airport>? airportListPopular,
    List<Airport>? airportListSearch,
    bool? isLoadingNearby,
    bool? isLoadingHistory,
    bool? isLoadingPopular,
    bool? isLoadingSearch,
    bool? isShowInfoWarning,
    bool? fromSearch,
    ServiceSearchType? serviceType,
  }) {
    return SearchAirportState(
      airportListNearby: airportListNearby ?? this.airportListNearby,
      airportListHistory: airportListHistory ?? this.airportListHistory,
      airportListPopular: airportListPopular ?? this.airportListPopular,
      airportListSearch: airportListSearch ?? this.airportListSearch,
      isLoadingNearby: isLoadingNearby ?? this.isLoadingNearby,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isLoadingPopular: isLoadingPopular ?? this.isLoadingPopular,
      isLoadingSearch: isLoadingSearch ?? this.isLoadingSearch,
      isShowInfoWarning: isShowInfoWarning ?? this.isShowInfoWarning,
      fromSearch: fromSearch ?? this.fromSearch,
      serviceType: serviceType ?? this.serviceType,
    );
  }
}
