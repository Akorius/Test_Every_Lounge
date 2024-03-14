import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/passengers.dart';
import 'package:flutter/cupertino.dart';

class LoungeState extends Equatable {
  final Lounge lounge;
  final bool isLoading;
  final bool isPayByCardLoading;
  final bool isAuth;
  final BankCard? activeBankCard;
  final bool canChangeName;
  final Passengers passenger;
  final int passengersCount;
  final String? nameError;
  final String? lastNameError;
  final bool cardsLoading;
  final bool isTranslitNames;
  final num price;
  final Uri? webViewPaymentUri;
  final Order? createdOrder;
  final bool needShowAttention;
  final double titleOpacity;

  const LoungeState({
    required this.lounge,
    this.isLoading = true,
    this.isPayByCardLoading = false,
    this.isAuth = false,
    this.canChangeName = false,
    this.activeBankCard,
    required this.passenger,
    this.passengersCount = 1,
    required this.nameError,
    required this.lastNameError,
    required this.price,
    this.createdOrder,
    this.cardsLoading = true,
    this.isTranslitNames = false,
    this.webViewPaymentUri,
    this.needShowAttention = false,
    this.titleOpacity = 1,
  });

  @override
  List<Object?> get props => [
        lounge,
        isLoading,
        isPayByCardLoading,
        isAuth,
        canChangeName,
        cardsLoading,
        activeBankCard,
        passenger,
        passengersCount,
        nameError,
        lastNameError,
        price,
        isTranslitNames,
        lounge,
        webViewPaymentUri,
        createdOrder,
        needShowAttention,
        titleOpacity
      ];

  LoungeState copyWith({
    Lounge? lounge,
    bool? isLoading,
    bool? isPayByCardLoading,
    bool? isAuth,
    bool? canChangeName,
    ValueGetter<BankCard?>? activeBankCard,
    Passengers? passenger,
    int? passengersCount,
    ValueGetter<String?>? nameError,
    ValueGetter<String?>? lastNameError,
    bool? cardsLoading,
    bool? isTranslitNames,
    num? price,
    Uri? webViewPaymentUri,
    Order? createdOrder,
    bool? needShowAttention,
    double? titleOpacity,
  }) {
    return LoungeState(
        lounge: lounge ?? this.lounge,
        isLoading: isLoading ?? this.isLoading,
        isPayByCardLoading: isPayByCardLoading ?? this.isPayByCardLoading,
        isAuth: isAuth ?? this.isAuth,
        canChangeName: canChangeName ?? this.canChangeName,
        activeBankCard: activeBankCard != null ? activeBankCard() : this.activeBankCard,
        passenger: passenger ?? this.passenger,
        passengersCount: passengersCount ?? this.passengersCount,
        nameError: nameError != null ? nameError() : this.nameError,
        lastNameError: lastNameError != null ? lastNameError() : this.lastNameError,
        cardsLoading: cardsLoading ?? this.cardsLoading,
        isTranslitNames: isTranslitNames ?? this.isTranslitNames,
        price: price ?? this.price,
        webViewPaymentUri: webViewPaymentUri ?? this.webViewPaymentUri,
        createdOrder: createdOrder ?? this.createdOrder,
        needShowAttention: needShowAttention ?? this.needShowAttention,
        titleOpacity: titleOpacity ?? this.titleOpacity);
  }

  static const String navigateToTinkoffWebView = "navigateToTinkoffWebView";
  static const String navigateToAlfaPayWebView = "navigateToAlfaPayWebView";
}
