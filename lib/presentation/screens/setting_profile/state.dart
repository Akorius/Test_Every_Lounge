import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/login/user.dart';

class ProfileSettingsState extends Equatable {
  final bool isLoading;
  final bool isConfirm;
  final User? user;
  final List<String>? reasons = [
    'Приложение больше не интересно',
    'Беспокоюсь за свои персональные данные',
    'Хочу отвязать почту',
    'Другое',
  ];
  final String? reasonValue;
  final String? emailError;
  final bool isDeveloper;
  final bool isRuble;
  final String? passwordError;

  ProfileSettingsState({
    this.isLoading = true,
    this.isConfirm = false,
    this.user,
    this.reasonValue,
    this.emailError = "",
    this.isDeveloper = false,
    this.isRuble = false,
    this.passwordError,
  });

  @override
  List<Object?> get props => [isLoading, isConfirm, user, reasons, reasonValue, isDeveloper, emailError, isRuble, passwordError];

  ProfileSettingsState copyWith({
    bool? isLoading,
    bool? isConfirm,
    User? user,
    String? reasonValue,
    bool? isDeveloper,
    bool? isRuble,
    String? emailError,
    String? passwordError,
  }) {
    return ProfileSettingsState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isConfirm: isConfirm ?? this.isConfirm,
      reasonValue: reasonValue ?? this.reasonValue,
      isDeveloper: isDeveloper ?? this.isDeveloper,
      emailError: emailError,
      isRuble: isRuble ?? this.isRuble,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  static const successRemoveAccount = "successRemoveAccount";
  static const logoutEvent = "logout";
}
