import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/upgrade_flight/aero_companies.dart';
import 'package:everylounge/domain/entities/upgrade_flight/passenger.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';
import 'package:flutter/material.dart';

class CreateUpgradeOrderState extends Equatable {
  final bool isLoading;
  final bool isPayByCardLoading;
  final bool canGetBookingDetails;
  final User? user;
  final AeroCompany currentCompany;
  final num? currentPrice;
  final bool cardsLoading;
  final bool attachingCard;
  final BankCard? activeCard;
  final bool payInProgress;
  final Uri? webViewPaymentUri;
  final Map<Segment, List<PassengerFU>> ticketToCardMap;
  final SearchedBooking searchedBooking;
  final Order? createdOrder;

  const CreateUpgradeOrderState({
    required this.searchedBooking,
    this.isLoading = false,
    this.isPayByCardLoading = false,
    this.canGetBookingDetails = false,
    this.user,
    this.currentCompany = AeroCompany.aeroflot,
    this.currentPrice,
    this.cardsLoading = true,
    this.attachingCard = false,
    this.activeCard,
    this.payInProgress = false,
    this.webViewPaymentUri,
    this.createdOrder,
    required this.ticketToCardMap,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isPayByCardLoading,
        canGetBookingDetails,
        user,
        currentCompany,
        currentPrice,
        cardsLoading,
        attachingCard,
        activeCard,
        payInProgress,
        webViewPaymentUri,
        ticketToCardMap,
        createdOrder,
        searchedBooking,
      ];

  CreateUpgradeOrderState copyWith({
    bool? isLoading,
    bool? isPayByCardLoading,
    bool? canGetBookingDetails,
    User? user,
    AeroCompany? currentCompany,
    num? currentPrice,
    bool? cardsLoading,
    bool? attachingCard,
    ValueGetter<BankCard?>? activeCard,
    bool? payInProgress,
    ValueGetter<Uri?>? webViewPaymentUri,
    Order? createdOrder,
  }) {
    return CreateUpgradeOrderState(
      isLoading: isLoading ?? this.isLoading,
      isPayByCardLoading: isPayByCardLoading ?? this.isPayByCardLoading,
      canGetBookingDetails: canGetBookingDetails ?? this.canGetBookingDetails,
      user: user ?? this.user,
      currentCompany: currentCompany ?? this.currentCompany,
      currentPrice: currentPrice ?? this.currentPrice,
      cardsLoading: cardsLoading ?? this.cardsLoading,
      attachingCard: attachingCard ?? this.attachingCard,
      activeCard: activeCard != null ? activeCard() : this.activeCard,
      payInProgress: payInProgress ?? this.payInProgress,
      webViewPaymentUri: webViewPaymentUri != null ? webViewPaymentUri() : this.webViewPaymentUri,
      searchedBooking: searchedBooking,
      createdOrder: createdOrder ?? this.createdOrder,
      ticketToCardMap: ticketToCardMap,
    );
  }

  bool get canPress {
    return (currentPrice ?? 0) > 0;
  }
}
