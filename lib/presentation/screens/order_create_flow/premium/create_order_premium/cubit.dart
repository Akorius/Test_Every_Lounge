import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/contacts.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/premium/flight_create_order_object.dart';
import 'package:everylounge/domain/entities/order/premium/premium_passengers.dart';
import 'package:everylounge/domain/entities/order/premium/premuim_create_order_object.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/domain/entities/validators/text_validators.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/order/create_order.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/translit.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/presentation/common/cubit/payment/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class CreateOrderPremiumCubit extends Cubit<CreateOrderPremiumState> {
  final GetCardsUseCase _getCardsUseCase = getIt();
  final GetUserUseCase _getUserUseCase = getIt();
  final TranslitUseCase _translitUseCase = getIt();
  final CreateOrderUseCase _createOrderUseCase = getIt();
  final PayOrderCubit payOrderCubit = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  CreateOrderPremiumCubit({
    required PremiumService service,
    required InnerDestinationType destinationType,
  }) : super(
          CreateOrderPremiumState(
              passengers: [PremiumPassengers(firstName: "", lastName: "", child: false)],
              nameControllers: [TextEditingController()],
              lastNameControllers: [TextEditingController()],
              nameErrors: const [null],
              lastNameErrors: const [null],
              service: service,
              destinationType: destinationType,
              canPressNextStep: false),
        ) {
    payOrderCubit.listen(
      (event) => emit(state.copyWith(isLoading: event.loading, webViewPaymentUri: event.webViewPaymentUri)),
      _messageController.add,
    );
    _onCreate();
  }

  final FlightTextFieldData flightArrivalData = FlightTextFieldData();
  final FlightTextFieldData flightDepartureData = FlightTextFieldData();

  ///Получаем карты, получем пользователя, выясняем транслитировать ли пассажиров,транслитируем
  //common
  _onCreate() async {
    await Future.wait([
      _getCardsUseCase.get(),
      _getUserUseCase.get(),
    ]);
    final user = await _getUserUseCase.stream.first;
    final result = await _getCardsUseCase.active(notFake: false);
    final translitName = _translitUseCase.findOut(state.service.airport.countryCode, state.service.organization);
    final name = translitName ? _translitUseCase.translit(user.profile.firstName).toUpperCase() : user.profile.firstName;
    final lastName = translitName ? _translitUseCase.translit(user.profile.lastName).toUpperCase() : user.profile.lastName;
    emit(
      state.copyWith(
        isTranslitNames: translitName,
        activeCard: result.isSuccess ? result.value : null,
        cardsLoading: false,
        passengers: [
          PremiumPassengers(
            firstName: name,
            lastName: lastName,
            child: false,
          )
        ],
      ),
    );
  }

  onFlightDataChanged(FlightTextFieldData data) {
    checkError(data);
    checkDate();
    checkCanPressNextStep();
  }

  void checkDate() {
    flightDepartureData.initialDate = flightArrivalData.date;
    var timeError = 'Время прилета раньше времени вылета';
    // проверить что data+time arrival < departure, иначе вывести ошибку
    if (flightArrivalData.date != null && flightArrivalData.time != null && flightArrivalData.flightDateError == null) {
      if (flightDepartureData.date != null &&
          flightDepartureData.time != null &&
          (flightDepartureData.flightDateError == null || flightDepartureData.flightDateError == timeError)) {
        var dateTimeArrival = DateTime(flightArrivalData.date!.year, flightArrivalData.date!.month, flightArrivalData.date!.day,
            flightArrivalData.time!.hour, flightArrivalData.time!.minute);
        var dateTimeDeparture = DateTime(flightDepartureData.date!.year, flightDepartureData.date!.month,
            flightDepartureData.date!.day, flightDepartureData.time!.hour, flightDepartureData.time!.minute);
        if (dateTimeArrival.difference(dateTimeDeparture).inMinutes > 0) {
          flightDepartureData.flightDateError = timeError;
        } else {
          flightDepartureData.flightDateError = null;
        }
      }
    }
  }

  checkError(FlightTextFieldData data) {
    final newError = TextValidators.flyNumber(data.flightNumberController.text);
    if (data.flightNumberError != newError) {
      data.flightNumberError = newError;
    }
    if (data.date != null && data.time != null && data.airport != null) {
      var limitHour = data.airport?.countryCode == "RU" ? 6 : 14;
      if (DateTime(data.date!.year, data.date!.month, data.date!.day, data.time!.hour, data.time!.minute)
              .difference(DateTime.now())
              .inHours <=
          limitHour) {
        data.flightDateError = "Не ранее $limitHour часов";
      } else {
        data.flightDateError = null;
      }
    }
  }

  onPassengerNameChanged(String firstName, int index) {
    state.passengers[index].firstName = firstName;
    final newError = TextValidators.name(firstName);
    if (state.nameErrors[index] != newError) {
      emit(state.copyWith(nameErrors: [...state.nameErrors]..[index] = newError));
    }
    checkCanPressNextStep();
  }

  onPassengerLastNameChanged(String lastName, int index) {
    state.passengers[index].lastName = lastName;
    final newError = TextValidators.name(lastName);
    if (state.lastNameErrors[index] != newError) {
      emit(state.copyWith(lastNameErrors: [...state.lastNameErrors]..[index] = newError));
    }
    checkCanPressNextStep();
  }

  onAddPassengerPressed() {
    state.nameControllers.add(TextEditingController());
    state.lastNameControllers.add(TextEditingController());
    emit(
      state.copyWith(
        passengers: [
          ...state.passengers,
          PremiumPassengers(
            firstName: "",
            lastName: "",
            child: false,
          ),
        ],
        nameErrors: [...state.nameErrors, null],
        lastNameErrors: [...state.lastNameErrors, null],
      ),
    );
    checkCanPressNextStep();
  }

  checkCanPressNextStep() {
    emit(state.copyWith(canPressNextStep: _canPressNextStep()));
  }

  onRemovePassengerPressed(int index) {
    emit(state.copyWith(
      passengers: [...state.passengers]..removeAt(index),
      nameErrors: [...state.nameErrors]..removeAt(index),
      lastNameErrors: [...state.lastNameErrors]..removeAt(index),
    ));
    state.nameControllers
      ..[index].dispose()
      ..removeAt(index);
    state.lastNameControllers
      ..[index].dispose()
      ..removeAt(index);
    checkCanPressNextStep();
  }

  onChildrenToggle(int index, bool isChild) async {
    final updatedPassenger = state.passengers[index].copyWith(child: isChild);
    if (!isChild) {
      updatedPassenger.childBirthDate = null;
    }
    emit(state.copyWith(passengers: [...state.passengers]..[index] = updatedPassenger));
    checkCanPressNextStep();
  }

  onChildrenDateSelect(int index, DateTime childBirthDate) {
    final updatedPassenger = state.passengers[index].copyWith(childBirthDate: childBirthDate);
    emit(state.copyWith(passengers: [...state.passengers]..[index] = updatedPassenger));
    checkCanPressNextStep();
  }

  bool get _canPressContinueFlightStep {
    var isCan = true;
    var list = [flightDepartureData, flightArrivalData];
    if (state.destinationType == InnerDestinationType.arrival) {
      list.remove(flightDepartureData);
    } else if (state.destinationType == InnerDestinationType.departure) {
      list.remove(flightArrivalData);
    }
    for (var element in list) {
      if (element.flightNumberError != null ||
          element.flightDateError != null ||
          element.date == null ||
          element.time == null ||
          element.airport == null ||
          element.flightNumberController.text.isEmpty) isCan = false;
    }
    return isCan;
  }

  void onStepBack() {
    if (state.currentStep == PremiumServiceCreateStep.passengers) {
      emit(state.copyWith(currentStep: PremiumServiceCreateStep.flight));
    } else if (state.currentStep == PremiumServiceCreateStep.payment) {
      emit(state.copyWith(currentStep: PremiumServiceCreateStep.passengers));
    }
  }

  bool _canPressNextStep() {
    if (state.currentStep == PremiumServiceCreateStep.flight) {
      return _canPressContinueFlightStep;
    } else {
      return state.canPressContinuePassengerStep;
    }
  }

  onTinkoffPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    if (state.createdOrder != null) {
      await payOrderCubit.onTinkoffPayPressed(state.createdOrder!);
      _navigateToOrderDetailsScreen();
    } else {
      _messageController.add(eventName[failCreateOrder]!);
      _metricsUseCase.sendEvent(error: eventName[failCreateOrder]!, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onPayWithCardPressed() async {
    if (state.isPayByCardLoading) return;
    emit(state.copyWith(isPayByCardLoading: true));
    if (state.createdOrder != null) {
      await payOrderCubit.onPayWithCardPressed(state.createdOrder!);
      _navigateToOrderDetailsScreen();
    } else {
      _messageController.add(eventName[failCreateOrder]!);
      _metricsUseCase.sendEvent(error: eventName[failCreateOrder]!, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isPayByCardLoading: false));
  }

  onAlfaPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    if (state.createdOrder != null) {
      await payOrderCubit.onAlfaPayPressed(state.createdOrder!);
      _navigateToOrderDetailsScreen();
    } else {
      _messageController.add(eventName[failCreateOrder]!);
      _metricsUseCase.sendEvent(error: eventName[failCreateOrder]!, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  onRecurrentPayPressed() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    if (state.createdOrder != null) {
      payOrderCubit.onRecurrentPayPressed(state.createdOrder!);
    } else {
      _messageController.add(eventName[failCreateOrder]!);
      _metricsUseCase.sendEvent(error: eventName[failCreateOrder]!, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
  }

  _navigateToOrderDetailsScreen() async {
    if (state.createdOrder != null) {
      _messageController.add(CreateOrderPremiumState.navigateToOrderDetailsScreen);
    }
  }

  onNextStepPressed() async {
    if (state.currentStep == PremiumServiceCreateStep.flight) {
      emit(state.copyWith(currentStep: PremiumServiceCreateStep.passengers));
    } else {
      await _createOrderObject();
    }
  }

  Future<Result<Order>> _createOrderObject() async {
    emit(state.copyWith(isLoading: true));
    final result = await _createOrderUseCase.createPremiumService(constructOrder());
    if (result.isSuccess) {
      emit(state.copyWith(createdOrder: result.value));
    }
    if (result.isSuccess) {
      emit(state.copyWith(createdOrder: result.value));
      if (result.value.status.index != OrderStatus.rejected.index) {
        emit(state.copyWith(currentStep: PremiumServiceCreateStep.payment));
      } else {
        _messageController.add(eventName[failCreateOrder]!);
        _metricsUseCase.sendEvent(error: eventName[failCreateOrder]!, type: MetricsEventType.alert);
      }
    } else {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(error: result.message, type: MetricsEventType.alert);
    }
    emit(state.copyWith(isLoading: false));
    return result;
  }

  PremiumCreateOrderObject constructOrder() {
    var flightsList = <FlightCreateOrderObject>[];
    if (flightDepartureData.airport != null) {
      addToFlights(flightsList, flightDepartureData, 'Departure');
    }
    if (flightArrivalData.airport != null) {
      addToFlights(flightsList, flightArrivalData, 'Arrival');
    }
    var createObject = PremiumCreateOrderObject(
      serviceId: state.service.id,
      contacts: Contacts(
        name: "${state.passengers[0].firstName} ${state.passengers[0].lastName}",
      ),
      passengers: state.passengers,
      flights: flightsList,
      isTransit: flightsList.length > 1,
    );
    return createObject;
  }

  void addToFlights(
    List<FlightCreateOrderObject> flightsList,
    FlightTextFieldData data,
    String type,
  ) {
    return flightsList.add(FlightCreateOrderObject(
      airportCode: data.airport?.code ?? '',
      date: data.date ?? DateTime.now(),
      time: data.time ?? TimeOfDay.now(),
      flightNumber: data.flightNumberController.text,
      direction: type,
    ));
  }

  @override
  Future<void> close() {
    _messageController.close();
    for (var value in state.nameControllers) {
      value.dispose();
    }
    for (var value in state.lastNameControllers) {
      value.dispose();
    }
    return super.close();
  }
}

class FlightTextFieldData {
  final flightNumberController = TextEditingController();
  DateTime? date;
  DateTime? initialDate;
  TimeOfDay? time;
  Airport? airport;
  String? flightNumberError;
  String? flightDateError;
}
