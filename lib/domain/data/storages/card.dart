import 'package:everylounge/domain/entities/bank/bin.dart';
import 'package:everylounge/domain/entities/bank/card.dart';

abstract class CardStorage {
  late final List<Bin>? bins;
  late final List<BankCard>? cards;
}
