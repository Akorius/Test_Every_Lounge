import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:flutter/cupertino.dart';

class PremiumDetailsState extends Equatable {
  final PremiumService service;
  final bool isLoading;
  final bool isAuth;
  final bool canPressAttach;
  final BankCard? activeBankCard;
  final InnerDestinationType destinationType;
  final double titleOpacity;

  const PremiumDetailsState({
    required this.service,
    this.isLoading = true,
    this.isAuth = false,
    this.canPressAttach = true,
    this.activeBankCard,
    required this.destinationType,
    this.titleOpacity = 1,
  });

  @override
  List<Object?> get props => [
        service,
        isLoading,
        isAuth,
        canPressAttach,
        activeBankCard,
        destinationType,
        titleOpacity,
      ];

  PremiumDetailsState copyWith({
    PremiumService? premiumService,
    InnerDestinationType? destinationType,
    bool? isLoading,
    bool? isAuth,
    bool? canPressAttach,
    double? titleOpacity,
    ValueGetter<BankCard?>? activeBankCard,
  }) {
    return PremiumDetailsState(
      service: premiumService ?? this.service,
      isLoading: isLoading ?? this.isLoading,
      isAuth: isAuth ?? this.isAuth,
      canPressAttach: canPressAttach ?? this.canPressAttach,
      activeBankCard: activeBankCard != null ? activeBankCard() : this.activeBankCard,
      destinationType: destinationType ?? this.destinationType,
      titleOpacity: titleOpacity ?? this.titleOpacity,
    );
  }

  static const String navigateToCreateOrder = "navigateToCreateOrder";
  static const String navigateToCreateOrderMeetAndAssist = "navigateToCreateOrderMeetAndAssist";
}
