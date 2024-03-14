import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';

class PremiumServicesListState extends Equatable {
  final Airport airport;
  final bool isLoading;
  final bool hasActiveCard;
  final List<PremiumService> servicesList;
  final InnerDestinationType destinationType;

  const PremiumServicesListState({
    required this.airport,
    this.isLoading = true,
    this.hasActiveCard = false,
    this.servicesList = const [],
    this.destinationType = InnerDestinationType.departure,
  });

  @override
  List<Object?> get props => [
        airport,
        isLoading,
        hasActiveCard,
        servicesList,
        destinationType,
      ];

  PremiumServicesListState copyWith({
    Airport? airport,
    bool? isLoading,
    bool? hasActiveCard,
    List<PremiumService>? servicesList,
    InnerDestinationType? destinationType,
  }) {
    return PremiumServicesListState(
        airport: airport ?? this.airport,
        isLoading: isLoading ?? this.isLoading,
        hasActiveCard: hasActiveCard ?? this.hasActiveCard,
        servicesList: servicesList ?? this.servicesList,
        destinationType: destinationType ?? this.destinationType);
  }
}
