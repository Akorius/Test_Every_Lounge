import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddBankByPhoneNumberState extends Equatable {
  final AddBankByPhoneNumberStep step;
  final TextEditingController phoneController;
  final String? phoneNumberError;

  String code;

  final bool canPressContinue;
  final bool canPressContinue2;
  final bool loading;
  final bool showTimer;
  final int timerSecondsLeft;

  AddBankByPhoneNumberState({
    this.step = AddBankByPhoneNumberStep.phone,
    this.phoneNumberError,
    this.code = "",
    this.canPressContinue = false,
    this.canPressContinue2 = false,
    this.loading = false,
    this.showTimer = false,
    required this.phoneController,
    this.timerSecondsLeft = 60,
  });

  @override
  List<Object?> get props => [
        step,
        phoneController,
        phoneNumberError,
        code,
        canPressContinue,
        canPressContinue2,
        loading,
        showTimer,
        timerSecondsLeft,
      ];

  AddBankByPhoneNumberState copyWith({
    AddBankByPhoneNumberStep? step,
    ValueGetter<String?>? phoneNumberError,
    String? code,
    bool? canPressContinue,
    bool? canPressContinue2,
    bool? loading,
    bool? showTimer,
    int? timerSecondsLeft,
  }) {
    return AddBankByPhoneNumberState(
      step: step ?? this.step,
      phoneController: phoneController,
      phoneNumberError: phoneNumberError != null ? phoneNumberError() : this.phoneNumberError,
      code: code ?? this.code,
      canPressContinue: canPressContinue ?? this.canPressContinue,
      canPressContinue2: canPressContinue2 ?? this.canPressContinue2,
      loading: loading ?? this.loading,
      showTimer: showTimer ?? this.showTimer,
      timerSecondsLeft: timerSecondsLeft ?? this.timerSecondsLeft,
    );
  }

  static const String successAddProgram = "successAddProgram";
}

enum AddBankByPhoneNumberStep { phone, code }
