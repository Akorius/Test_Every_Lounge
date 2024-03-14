import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/premium/premium_passengers.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreateOrderPremiumState extends Equatable {
  //common:
  final PremiumService service;
  final InnerDestinationType destinationType;
  final bool canPressNextStep;

  //passenger step:
  final List<PremiumPassengers> passengers;
  final List<TextEditingController> nameControllers;
  final List<TextEditingController> lastNameControllers;
  final List<String?> nameErrors;
  final List<String?> lastNameErrors;
  final bool isTranslitNames;

  //pay step:
  final BankCard? activeCard;
  final bool isLoading;
  final bool isPayByCardLoading;
  final bool cardsLoading;
  Uri? webViewPaymentUri;
  final Order? createdOrder;

  final PremiumServiceCreateStep currentStep;

  CreateOrderPremiumState({
    //common:
    required this.service,
    required this.destinationType,
    required this.canPressNextStep,

    //passenger step:
    required this.passengers,
    required this.lastNameControllers,
    required this.nameControllers,
    required this.nameErrors,
    required this.lastNameErrors,
    this.isTranslitNames = true,

    //pay step:
    this.isLoading = false,
    this.isPayByCardLoading = false,
    this.createdOrder,
    this.cardsLoading = true,
    this.activeCard,
    this.webViewPaymentUri,
    this.currentStep = PremiumServiceCreateStep.flight,
  });

  @override
  List<Object?> get props => [
        passengers,
        nameErrors,
        lastNameErrors,
        activeCard,
        isLoading,
        isPayByCardLoading,
        isTranslitNames,
        service,
        webViewPaymentUri,
        createdOrder,
        destinationType,
        canPressNextStep,
        currentStep
      ];

  static const String navigateToTinkoffWebView = "navigateToTinkoffWebView";
  static const String navigateToAlfaWebView = "navigateToAlfaWebView";
  static const String navigateToOrderDetailsScreen = "navigateToOrderDetailsScreen";

  bool get canPressContinuePassengerStep {
    return !nameErrors.any((element) => element != null) &&
        !lastNameErrors.any((element) => element != null) &&
        !passengers.any((element) => element.firstName.isEmpty || element.lastName.isEmpty) &&
        !passengers.any((element) => element.child && element.childBirthDate == null);
  }

  CreateOrderPremiumState copyWith({
    List<PremiumPassengers>? passengers,
    List<String?>? nameErrors,
    List<String?>? lastNameErrors,
    BankCard? activeCard,
    bool? isLoading,
    bool? isPayByCardLoading,
    bool? cardsLoading,
    bool? isTranslitNames,
    PremiumService? service,
    Uri? webViewPaymentUri,
    Order? createdOrder,
    PremiumServiceCreateStep? currentStep,
    bool? canPressNextStep,
    InnerDestinationType? destinationType,
  }) {
    return CreateOrderPremiumState(
      passengers: passengers ?? this.passengers,
      nameErrors: nameErrors ?? this.nameErrors,
      lastNameErrors: lastNameErrors ?? this.lastNameErrors,
      activeCard: activeCard ?? this.activeCard,
      isLoading: isLoading ?? this.isLoading,
      isPayByCardLoading: isPayByCardLoading ?? this.isPayByCardLoading,
      cardsLoading: cardsLoading ?? this.cardsLoading,
      isTranslitNames: isTranslitNames ?? this.isTranslitNames,
      service: service ?? this.service,
      webViewPaymentUri: webViewPaymentUri ?? this.webViewPaymentUri,
      createdOrder: createdOrder ?? this.createdOrder,
      destinationType: destinationType ?? this.destinationType,
      nameControllers: nameControllers,
      lastNameControllers: lastNameControllers,
      currentStep: currentStep ?? this.currentStep,
      canPressNextStep: canPressNextStep ?? this.canPressNextStep,
    );
  }
}

enum PremiumServiceCreateStep {
  flight,
  passengers,
  payment,
}
