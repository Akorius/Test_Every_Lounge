import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/settings/settings.dart';
import 'package:flutter/material.dart';

class HomeBottomState extends Equatable {
  final bool isCheckUpdating;
  final int currentScreen;
  final AppSettings? appSettings;
  final List<Order>? orders;

  const HomeBottomState({
    this.isCheckUpdating = true,
    this.currentScreen = 0,
    this.appSettings,
    this.orders,
  });

  @override
  List<Object?> get props => [
        isCheckUpdating,
        currentScreen,
        appSettings,
        orders,
      ];

  HomeBottomState copyWith({
    ValueGetter<AppSettings?>? appSettings,
    int? currentScreen,
    bool? isCheckUpdating,
    List<Order>? orders,
  }) {
    return HomeBottomState(
      isCheckUpdating: isCheckUpdating ?? this.isCheckUpdating,
      currentScreen: currentScreen ?? this.currentScreen,
      orders: orders ?? this.orders,
      appSettings: appSettings != null ? appSettings() : this.appSettings,
    );
  }

  static const String showUpdateAppScreen = "showUpdateAppScreen";
  static const String showUpdateAppModal = "showUpdateAppModal";
}
