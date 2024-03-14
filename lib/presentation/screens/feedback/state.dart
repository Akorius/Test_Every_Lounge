part of 'cubit.dart';

class FeedbackState extends Equatable {
  final bool isLoading;
  final List<bool> buttons;
  final List<Faq>? faq;
  final bool? canPress;
  final String? emailError;
  final User? user;

  const FeedbackState({
    this.isLoading = false,
    this.canPress = false,
    this.buttons = const [],
    this.faq,
    this.emailError,
    this.user,
  });

  @override
  List<Object?> get props => [
        isLoading,
        faq,
        buttons,
        canPress,
        emailError,
        user,
      ];

  FeedbackState copyWith({
    required bool isLoading,
    List<bool>? buttons,
    bool? canPress,
    List<Faq>? faq,
    User? user,
    String? emailError,
  }) {
    return FeedbackState(
      isLoading: isLoading,
      buttons: buttons ?? this.buttons,
      canPress: canPress ?? false,
      faq: faq ?? this.faq,
      user: user ?? this.user,
      emailError: emailError,
    );
  }
}
