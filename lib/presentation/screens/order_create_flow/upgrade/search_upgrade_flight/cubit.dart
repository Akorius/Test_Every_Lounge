import 'dart:async';

import 'package:collection/collection.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/upgrade_flight/aero_companies.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/upgrades/search_aeroflot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class SearchUpgradeFlightCubit extends Cubit<UpgradeFlightState> {
  final GetCardsUseCase _getCardsUseCase = getIt();
  final SearchTicketUseCase _searchTicketUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<List<BankCard>> _cardsSubscription;

  SearchUpgradeFlightCubit() : super(const UpgradeFlightState()) {
    onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  final TextEditingController surnameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  void onCreate() async {
    _cardsSubscription = _getCardsUseCase.stream.listen((cards) async {
      final activeCard = cards.firstWhereOrNull((element) => element.isActive);
      emit(state.copyWith(cardsLoading: false, activeCard: () => activeCard));
    });
  }

  onClearSurname() {
    surnameController.clear();
    validateBookingData();
  }

  onClearCode() {
    codeController.clear();
    validateBookingData();
  }

  void validateBookingData() {
    if (surnameController.text.isNotEmpty && codeController.text.length == 6) {
      emit(state.copyWith(canGetBookingDetails: true));
    } else {
      emit(state.copyWith(canGetBookingDetails: false));
    }
  }

  void onPressedContinue() async {
    emit(state.copyWith(isLoading: true));

    var result = await _searchTicketUseCase.search(codeController.text, surnameController.text);
    if (result.isSuccess) {
      emit(state.copyWith(searchData: result.value));
      _messageController.add(UpgradeFlightState.successSearchTicketEvent);
    } else {
      emit(state.copyWith(errorMessage: () => result.message));
    }

    emit(state.copyWith(isLoading: false));
  }

  void onPressedContinueMock() async {
    emit(state.copyWith(searchData: SearchedBooking.mock()));
    _messageController.add(UpgradeFlightState.successSearchTicketEvent);
  }

  void changeCompany(AeroCompany company) {
    emit(state.copyWith(currentCompany: company));
  }

  sendEventClick(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  @override
  Future<void> close() {
    return Future.wait([
      _cardsSubscription.cancel(),
    ]).then((value) => super.close());
  }

  void disableNotification() {
    emit(state.copyWith(errorMessage: () => null));
  }
}
