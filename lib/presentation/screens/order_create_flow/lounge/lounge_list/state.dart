import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';

class LoungeListState extends Equatable {
  final Airport? airport;
  final bool isLoading;
  final bool isLoungeLoading;
  final bool isAuth;
  final bool isPayByPass;
  final List<Lounge> loungeListAll;
  final List<Lounge> loungeListInternational;
  final List<Lounge> loungeListDomestic;
  final BankCard? activeCard;
  final int selectedIndex;

  const LoungeListState({
    required this.airport,
    this.loungeListAll = const [],
    this.loungeListInternational = const [],
    this.loungeListDomestic = const [],
    this.isLoading = true,
    this.isLoungeLoading = true,
    this.isAuth = false,
    this.isPayByPass = false,
    this.activeCard,
    this.selectedIndex = 0,
  });

  @override
  List<Object?> get props => [
        airport,
        isLoading,
        isLoungeLoading,
        loungeListAll,
        loungeListInternational,
        loungeListDomestic,
        isAuth,
        isPayByPass,
        activeCard,
        selectedIndex,
      ];

  LoungeListState copyWith({
    Airport? airport,
    bool? isLoading,
    bool? isLoungeLoading,
    bool? isPayByPass,
    List<Lounge>? loungeListAll,
    List<Lounge>? loungeListInternational,
    List<Lounge>? loungeListDomestic,
    bool? isAuth,
    BankCard? activeCard,
    int? selectedIndex,
  }) {
    return LoungeListState(
      airport: airport ?? this.airport,
      isLoading: isLoading ?? this.isLoading,
      isLoungeLoading: isLoungeLoading ?? this.isLoungeLoading,
      loungeListAll: loungeListAll ?? this.loungeListAll,
      loungeListInternational: loungeListInternational ?? this.loungeListInternational,
      loungeListDomestic: loungeListDomestic ?? this.loungeListDomestic,
      isAuth: isAuth ?? this.isAuth,
      isPayByPass: isPayByPass ?? this.isPayByPass,
      activeCard: activeCard ?? this.activeCard,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
