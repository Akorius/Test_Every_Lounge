import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_check.dart';
import 'package:flutter/material.dart';

class OrderDetailsState extends Equatable {
  final Order order;
  final bool isSharing;
  final bool payInProgress;
  final bool isPayByCardLoading;
  final bool cardsLoading;
  final bool attachingCard;
  final BankCard? activeCard;
  final Uri? webViewPaymentUri;
  final PassageCheck? orderCheck;
  final InnerDestinationType? destinationType;

  const OrderDetailsState(
      {required this.order,
      this.isSharing = false,
      this.payInProgress = false,
      this.isPayByCardLoading = false,
      this.cardsLoading = true,
      this.attachingCard = false,
      this.activeCard,
      this.webViewPaymentUri,
      this.orderCheck,
      this.destinationType});

  @override
  List<Object?> get props => [
        order,
        isSharing,
        payInProgress,
        isPayByCardLoading,
        cardsLoading,
        attachingCard,
        activeCard,
        webViewPaymentUri,
        orderCheck,
        destinationType
      ];

  OrderDetailsState copyWith({
    Order? order,
    bool? isSharing,
    bool? payInProgress,
    bool? isPayByCardLoading,
    bool? cardsLoading,
    bool? attachingCard,
    ValueGetter<BankCard?>? activeCard,
    ValueGetter<Uri?>? webViewPaymentUri,
    PassageCheck? orderCheck,
    InnerDestinationType? destinationType,
  }) {
    return OrderDetailsState(
        order: order ?? this.order,
        isSharing: isSharing ?? this.isSharing,
        payInProgress: payInProgress ?? this.payInProgress,
        isPayByCardLoading: isPayByCardLoading ?? this.isPayByCardLoading,
        cardsLoading: cardsLoading ?? this.cardsLoading,
        attachingCard: attachingCard ?? this.attachingCard,
        activeCard: activeCard != null ? activeCard() : this.activeCard,
        webViewPaymentUri: webViewPaymentUri != null ? webViewPaymentUri() : this.webViewPaymentUri,
        orderCheck: orderCheck ?? this.orderCheck,
        destinationType: destinationType ?? this.destinationType);
  }
}
