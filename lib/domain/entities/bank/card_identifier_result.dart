import 'package:everylounge/domain/entities/bank/card_type.dart';

class BankCardIdentifierResult {
  final BankCardType cardType;
  final int freeSelfPassesCount;
  final int freeGuestsPassesCount;

  BankCardIdentifierResult(this.cardType, this.freeSelfPassesCount, this.freeGuestsPassesCount);
}
