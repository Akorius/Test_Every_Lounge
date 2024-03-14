// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class NeedSetEmailState extends Equatable {
  final bool canPress;
  final bool emailLoading;
  final String? emailError;

  String email;

  NeedSetEmailState({
    this.canPress = true,
    this.emailLoading = false,
    this.email = "",
    this.emailError,
  });

  @override
  List<Object?> get props => [
        canPress,
        emailLoading,
        emailError,
        email,
      ];

  NeedSetEmailState copyWith({
    bool? canPress,
    bool? emailLoading,
    String? emailError,
    String? email,
  }) {
    return NeedSetEmailState(
      canPress: canPress ?? this.canPress,
      emailLoading: emailLoading ?? this.emailLoading,
      emailError: emailError,
      email: email ?? this.email,
    );
  }

  static const String navigateToCodeSend = "navigateToCodeSend";
  static const String logout = "logout";
}
