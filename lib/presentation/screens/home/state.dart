import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/settings/settings.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  final bool profileLoading;
  final bool ordersLoading;
  final bool cardsLoading;
  final bool addCardModalWasShown;
  final bool cardAttaching;
  final List<Order> activeOrdersList;
  final bool isCheckUpdating;
  final User? user;
  final BankCard? activeBankCard;
  final AppSettings? appSettings;
  final bool hideLounge;
  final bool hideUpgrades;
  final bool hideMeetAndAssist;
  final bool hideBanks;
  final int orderIndex;
  final bool isServicesLoading;

  const HomeState({
    this.profileLoading = true,
    this.ordersLoading = true,
    this.cardsLoading = true,
    this.addCardModalWasShown = false,
    this.cardAttaching = false,
    this.isCheckUpdating = true,
    this.activeOrdersList = const [],
    this.user,
    this.activeBankCard,
    this.appSettings,
    this.hideLounge = false,
    this.hideUpgrades = false,
    this.hideMeetAndAssist = false,
    this.hideBanks = false,
    this.orderIndex = 0,
    this.isServicesLoading = true,
  });

  @override
  List<Object?> get props => [
        profileLoading,
        ordersLoading,
        cardsLoading,
        addCardModalWasShown,
        cardAttaching,
        isCheckUpdating,
        activeOrdersList,
        user,
        activeBankCard,
        appSettings,
        hideLounge,
        hideUpgrades,
        hideMeetAndAssist,
        hideBanks,
        orderIndex,
        isServicesLoading
      ];

  HomeState copyWith({
    bool? profileLoading,
    bool? ordersLoading,
    bool? cardsLoading,
    bool? addCardModalWasShown,
    bool? cardAttaching,
    List<Order>? activeOrdersList,
    bool? isCheckUpdating,
    User? user,
    ValueGetter<BankCard?>? activeBankCard,
    ValueGetter<AppSettings?>? appSettings,
    bool? hideLounge,
    bool? hideUpgrades,
    bool? hideMeetAndAssist,
    bool? hideBanks,
    bool? isServicesLoading,
    int? orderIndex,
  }) {
    return HomeState(
      profileLoading: profileLoading ?? this.profileLoading,
      ordersLoading: ordersLoading ?? this.ordersLoading,
      cardsLoading: cardsLoading ?? this.cardsLoading,
      addCardModalWasShown: addCardModalWasShown ?? this.addCardModalWasShown,
      cardAttaching: cardAttaching ?? this.cardAttaching,
      activeOrdersList: activeOrdersList ?? this.activeOrdersList,
      isCheckUpdating: isCheckUpdating ?? this.isCheckUpdating,
      user: user ?? this.user,
      activeBankCard: activeBankCard != null ? activeBankCard() : this.activeBankCard,
      appSettings: appSettings != null ? appSettings() : this.appSettings,
      hideLounge: hideLounge ?? this.hideLounge,
      hideUpgrades: hideUpgrades ?? this.hideUpgrades,
      hideMeetAndAssist: hideMeetAndAssist ?? this.hideMeetAndAssist,
      hideBanks: hideBanks ?? this.hideBanks,
      isServicesLoading: isServicesLoading ?? this.isServicesLoading,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  static const String showAddCardModal = "showAddCardModal";
  static const String showAuthorizeModal = "showAuthorizeModal";
  static const String showNeedSetEmailScreen = "showNeedSetEmailScreen";
  static const String showRateAppModal = "showRateAppModal";
}
