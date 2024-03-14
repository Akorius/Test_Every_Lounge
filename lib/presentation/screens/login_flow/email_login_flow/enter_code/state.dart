// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class EnterCodeState extends Equatable {
  final bool loading;
  final bool codeValid;
  String code;
  final bool showTimer;

  bool get canPress => !loading && codeValid;

  bool get canEditPin => !loading;

  EnterCodeState({
    this.code = "",
    this.codeValid = false,
    this.loading = false,
    this.showTimer = false,
  });

  @override
  List<Object?> get props => [
        canPress,
        loading,
        code,
        codeValid,
        showTimer,
        canEditPin,
      ];

  EnterCodeState copyWith({
    bool? loading,
    bool? codeValid,
    String? code,
    bool? showTimer,
  }) {
    return EnterCodeState(
      loading: loading ?? this.loading,
      codeValid: codeValid ?? this.codeValid,
      code: code ?? this.code,
      showTimer: showTimer ?? this.showTimer,
    );
  }

  static const String navigateToMainScreen = "navigateToMainScreen";
}
