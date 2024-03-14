import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';

class BankProgramDetailedState extends Equatable {
  final BankCard bankCard;
  final bool loading;

  const BankProgramDetailedState({
    required this.bankCard,
    this.loading = false,
  });

  BankProgramDetailedState copyWith({
    BankCard? bankCard,
    bool? canPress,
    bool? loading,
  }) {
    return BankProgramDetailedState(
      loading: loading ?? this.loading,
      bankCard: bankCard ?? this.bankCard,
    );
  }

  @override
  List<Object?> get props => [loading, bankCard];

  static const String successRemoveBankCardEvent = "navigateToProfile";
}
