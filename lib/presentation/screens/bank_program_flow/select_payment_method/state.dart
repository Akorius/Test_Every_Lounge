import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/selected_bank.dart';
import 'package:flutter/material.dart';

class SelectPaymentMethodState extends Equatable {
  final bool excludeTinkoff;
  final bool excludeTochka;
  final bool excludeBeelineKZ;
  final bool excludeAlfa;
  final bool excludeAlfaPrem;

  final bool hideTochka;
  final bool hideBeelineKZ;
  final bool hideAlfaPrem;

  final String? alfaAuthLink;

  final bool canPress;

  ///для обработки лоадера
  final PaymentMethod? methodInHandle;
  final BankCard? activeCard;

  const SelectPaymentMethodState({
    this.excludeTinkoff = false,
    this.excludeTochka = false,
    this.excludeBeelineKZ = false,
    this.excludeAlfa = false,
    this.excludeAlfaPrem = false,
    this.hideTochka = false,
    this.hideBeelineKZ = false,
    this.hideAlfaPrem = false,
    this.canPress = true,
    this.methodInHandle,
    this.alfaAuthLink,
    this.activeCard,
  });

  @override
  List<Object?> get props => [
        excludeTinkoff,
        excludeTochka,
        excludeBeelineKZ,
        excludeAlfa,
        excludeAlfaPrem,
        hideTochka,
        hideBeelineKZ,
        hideAlfaPrem,
        canPress,
        methodInHandle,
        alfaAuthLink ?? '',
        activeCard,
      ];

  SelectPaymentMethodState copyWith({
    bool? excludeTinkoff,
    bool? excludeTochka,
    bool? excludeBeelineKZ,
    bool? excludeAlfa,
    bool? excludeAlfaPrem,
    bool? hideTochka,
    bool? hideBeelineKZ,
    bool? hideAlfaPrem,
    bool? canPress,
    ValueGetter<PaymentMethod?>? methodInHandle,
    String? alfaAuthLink,
    BankCard? activeCard,
  }) {
    return SelectPaymentMethodState(
      excludeTinkoff: excludeTinkoff ?? this.excludeTinkoff,
      excludeTochka: excludeTochka ?? this.excludeTochka,
      excludeBeelineKZ: excludeBeelineKZ ?? this.excludeBeelineKZ,
      excludeAlfa: excludeAlfa ?? this.excludeAlfa,
      excludeAlfaPrem: excludeAlfaPrem ?? this.excludeAlfaPrem,
      hideTochka: hideTochka ?? this.hideTochka,
      hideBeelineKZ: hideBeelineKZ ?? this.hideBeelineKZ,
      hideAlfaPrem: hideAlfaPrem ?? this.hideAlfaPrem,
      canPress: canPress ?? this.canPress,
      methodInHandle: methodInHandle != null ? methodInHandle() : this.methodInHandle,
      alfaAuthLink: alfaAuthLink ?? this.alfaAuthLink,
      activeCard: activeCard ?? this.activeCard,
    );
  }

  static const String navigateToTochka = "navigateToTochka";
  static const String navigateToAlfa = "navigateToAlfa";
  static const String navigateToAlfaPrem = "navigateToAlfaPrem";
  static const String navigateToBeelineKZ = "navigateToBeelineKZ";
  static const String navigateToTinkoffWebView = "navigateToTinkoffWebView";
  static const String navigateToProfile = "navigateToProfile";
  static const String showSuccess = "showSuccess";
}
