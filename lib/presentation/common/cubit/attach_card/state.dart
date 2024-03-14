import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:flutter/cupertino.dart';

class AttachCardState extends Equatable {
  final bool cardAttaching;
  final BankCard? attachedCard;

  const AttachCardState({
    this.cardAttaching = false,
    this.attachedCard,
  });

  @override
  List<Object?> get props => [
        cardAttaching,
        attachedCard,
      ];

  AttachCardState copyWith({
    bool? cardAttaching,
    ValueGetter<BankCard?>? attachedCard,
  }) {
    return AttachCardState(
      cardAttaching: cardAttaching ?? this.cardAttaching,
      attachedCard: attachedCard != null ? attachedCard() : this.attachedCard,
    );
  }

  static const String successAddBankCardEvent = "successAddBankCardEvent";
}
