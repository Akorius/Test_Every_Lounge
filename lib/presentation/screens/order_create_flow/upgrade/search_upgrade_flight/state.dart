import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/upgrade_flight/aero_companies.dart';
import 'package:everylounge/domain/entities/upgrade_flight/search_booking.dart';
import 'package:flutter/material.dart';

class UpgradeFlightState extends Equatable {
  final bool isLoading;
  final bool canGetBookingDetails;
  final AeroCompany currentCompany;
  final SearchedBooking? searchData;
  final bool cardsLoading;
  final String? errorMessage;
  final BankCard? activeCard;

  const UpgradeFlightState({
    this.isLoading = false,
    this.canGetBookingDetails = false,
    this.currentCompany = AeroCompany.aeroflot,
    this.searchData,
    this.cardsLoading = true,
    this.errorMessage,
    this.activeCard,
  });

  @override
  List<Object?> get props => [
        isLoading,
        canGetBookingDetails,
        currentCompany,
        searchData,
        cardsLoading,
        activeCard,
        errorMessage,
      ];

  UpgradeFlightState copyWith({
    bool? isLoading,
    bool? canGetBookingDetails,
    AeroCompany? currentCompany,
    SearchedBooking? searchData,
    bool? cardsLoading,
    ValueGetter<String?>? errorMessage,
    ValueGetter<BankCard?>? activeCard,
  }) {
    return UpgradeFlightState(
      isLoading: isLoading ?? this.isLoading,
      canGetBookingDetails: canGetBookingDetails ?? this.canGetBookingDetails,
      currentCompany: currentCompany ?? this.currentCompany,
      searchData: searchData ?? this.searchData,
      cardsLoading: cardsLoading ?? this.cardsLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      activeCard: activeCard != null ? activeCard() : this.activeCard,
    );
  }

  static const String successSearchTicketEvent = "successSearchTicketEvent";
}
