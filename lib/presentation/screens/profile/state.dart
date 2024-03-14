import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/user.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isPhotoInteraction;
  final User? user;
  final List<BankCard>? activeBankProgramsList;
  final List<BankCard>? inactiveBankProgramsList;
  final bool hideBanks;
  final bool isCardAttaching;

  const ProfileState({
    this.isLoading = true,
    this.isPhotoInteraction = false,
    this.user,
    this.activeBankProgramsList,
    this.inactiveBankProgramsList,
    this.hideBanks = false,
    this.isCardAttaching = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        isPhotoInteraction,
        user,
        activeBankProgramsList,
        inactiveBankProgramsList,
        hideBanks,
        isCardAttaching,
      ];

  ProfileState copyWith({
    bool? isLoading,
    bool? isPhotoInteraction,
    User? user,
    List<BankCard>? activeBankProgramsList,
    List<BankCard>? inactiveBankProgramsList,
    bool? hideBanks,
    bool? isCardAttaching,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isPhotoInteraction: isPhotoInteraction ?? this.isPhotoInteraction,
      user: user ?? this.user,
      activeBankProgramsList: activeBankProgramsList ?? this.activeBankProgramsList,
      inactiveBankProgramsList: inactiveBankProgramsList ?? this.inactiveBankProgramsList,
      hideBanks: hideBanks ?? this.hideBanks,
      isCardAttaching: isCardAttaching ?? this.isCardAttaching,
    );
  }
}
