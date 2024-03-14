// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class OtherLoginState extends Equatable {
  final bool canPress;
  final bool canPressEmailLogin;
  final bool googleLoading;
  final bool appleLoading;
  final bool emailLoading;
  final bool tinkoffLoading;
  final bool alfaLoading;
  final String alfaAuthLink;
  final String? emailError; //copy with without ??
  final bool hideTinkoff;
  final bool hideAlfa;

  OtherLoginState({
    this.canPress = true,
    this.canPressEmailLogin = false,
    this.googleLoading = false,
    this.appleLoading = false,
    this.emailLoading = false,
    this.tinkoffLoading = false,
    this.alfaLoading = false,
    this.alfaAuthLink = '',
    this.emailError,
    this.hideTinkoff = false,
    this.hideAlfa = false,
  });

  @override
  List<Object?> get props => [
        canPress,
        canPressEmailLogin,
        googleLoading,
        appleLoading,
        alfaLoading,
        alfaAuthLink,
        emailLoading,
        emailError,
        hideTinkoff,
        hideAlfa,
      ];

  OtherLoginState copyWith({
    bool? canPress,
    bool? canPressEmailLogin,
    bool? googleLoading,
    bool? appleLoading,
    bool? emailLoading,
    bool? tinkoffLoading,
    bool? alfaLoading,
    String? alfaAuthLink,
    String? emailError,
    bool? hideTinkoff,
    bool? hideAlfa,
  }) {
    return OtherLoginState(
      canPress: canPress ?? this.canPress,
      canPressEmailLogin: canPressEmailLogin ?? this.canPressEmailLogin,
      googleLoading: googleLoading ?? this.googleLoading,
      appleLoading: appleLoading ?? this.appleLoading,
      emailLoading: emailLoading ?? this.emailLoading,
      tinkoffLoading: tinkoffLoading ?? this.tinkoffLoading,
      alfaLoading: alfaLoading ?? this.alfaLoading,
      alfaAuthLink: alfaAuthLink ?? this.alfaAuthLink,
      emailError: emailError,
      hideTinkoff: hideTinkoff ?? this.hideTinkoff,
      hideAlfa: hideAlfa ?? this.hideAlfa,
    );
  }

  static const String navigateToCodeSend = "navigateToCodeSend";
  static const String navigateToMainScreen = "navigateToMainScreen";
  static const String navigateToBusynessLoungeScreen = "navigateToBusynessLoungeScreen";
  static const String navigateToTinkoffWebView = "NavigateToTinkoffLogin";
  static const String navigateToAlfaWebView = "navigateToAlfaWebView";
}
