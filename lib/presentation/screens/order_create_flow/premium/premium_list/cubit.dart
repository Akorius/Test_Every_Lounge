import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/domain/usecases/premium/get_premium.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class PremiumServicesListCubit extends Cubit<PremiumServicesListState> {
  final GetPremiumServicesUseCase _getPremiumServicesUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  late final StreamSubscription<List<BankCard>> _cardsStreamSubscription;

  PremiumServicesListCubit({
    required Airport airport,
  }) : super(PremiumServicesListState(airport: airport)) {
    _onCreate(airport.code);
  }

  _onCreate(String airportCode) async {
    final result = await _getPremiumServicesUseCase.get(airportCode);
    if (result.isSuccess) {
      emit(state.copyWith(servicesList: result.value));
    } else {
      _messageController.add(result.message);
    }
    _cardsStreamSubscription = _getCardsUseCase.stream.listen((event) {
      final activeCard = event.firstWhereOrNull((element) => element.isActive);
      emit(state.copyWith(
        isLoading: false,
        hasActiveCard: activeCard != null,
      ));
    });
  }

  List<PremiumService> getServicesList() {
    switch (state.destinationType) {
      case InnerDestinationType.transit:
        return state.servicesList.where((element) => element.isTransit == true).toList();
      case InnerDestinationType.arrival:
        return state.servicesList
            .where((element) => (element.type == AirportDestinationType.arrival || element.type == AirportDestinationType.any))
            .toList();
      case InnerDestinationType.departure:
      default:
        return state.servicesList
            .where((element) => (element.type == AirportDestinationType.departure || element.type == AirportDestinationType.any))
            .toList();
    }
  }

  onAirportDestinationSelected(int index) {
    late final InnerDestinationType type;
    switch (index) {
      case 0:
        type = InnerDestinationType.departure;
        break;
      case 1:
        type = InnerDestinationType.arrival;
        break;
      case 2:
        type = InnerDestinationType.transit;
        break;
    }
    emit(state.copyWith(destinationType: type));
  }

  @override
  Future<void> close() {
    return Future.wait([
      _cardsStreamSubscription.cancel(),
      _messageController.close(),
    ]).then(
      (value) => super.close(),
    );
  }
}
