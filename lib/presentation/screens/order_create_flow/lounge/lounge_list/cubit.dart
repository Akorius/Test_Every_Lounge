import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/domain/usecases/lounge/get_airport.dart';
import 'package:everylounge/domain/usecases/lounge/get_lounges.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class LoungeListCubit extends Cubit<LoungeListState> {
  final GetLoungesUseCase _getLoungesUseCase = getIt();
  final GetAirportUseCase _getAirportUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<List<BankCard>> _cardsStreamSubscription;
  late final StreamSubscription<User> _userStreamSubscription;

  LoungeListCubit({
    required Airport? airport,
    required String airportCode,
  }) : super(LoungeListState(airport: airport)) {
    _onCreate(airportCode);
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  _onCreate(String airportCode) async {
    ///Если зашли по ссылке в вебе, получаем аэропорт
    if (state.airport == null) {
      final result = await _getAirportUseCase.get(airportCode);
      if (result.isSuccess) {
        emit(state.copyWith(
          airport: result.value,
        ));
      } else {
        _messageController.add(result.message);
        return;
      }
    } else {
      _getAirportUseCase.get(airportCode);
    }

    final result = await _getLoungesUseCase.get(airportCode);
    if (result.isSuccess) {
      emit(state.copyWith(
        loungeListAll: result.value,
        loungeListDomestic: result.value
            .where((el) =>
                el.flightDirection == FlightDirection.domesticFlightDirection ||
                el.flightDirection == FlightDirection.anyFlightDirection)
            .toList(),
        loungeListInternational: result.value
            .where((el) =>
                el.flightDirection == FlightDirection.internFlightDirection ||
                el.flightDirection == FlightDirection.anyFlightDirection)
            .toList(),
        isLoungeLoading: false,
      ));
    } else {
      _messageController.add(result.message);
    }
    _cardsStreamSubscription = _getCardsUseCase.stream.listen((event) {
      final activeCard = event.firstWhereOrNull((element) => element.isActive);
      emit(state.copyWith(
        isLoading: false,
        activeCard: activeCard,
        isPayByPass: activeCard?.cardForPaymentByPasses == true && (activeCard?.passesCount ?? 0) != 0,
      ));
    });
    _userStreamSubscription = _getUserUseCase.stream.listen((user) {
      emit(state.copyWith(
        isAuth: user.authType != AuthType.anon,
      ));
    });
  }

  void changeIndexTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  sendEventClick(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  sendEventError(String event) {
    _metricsUseCase.sendEvent(error: event, type: MetricsEventType.alert);
  }

  @override
  Future<void> close() {
    return Future.wait([
      _cardsStreamSubscription.cancel(),
      _userStreamSubscription.cancel(),
      _messageController.close(),
    ]).then(
      (value) => super.close(),
    );
  }
}
