import 'package:everylounge/domain/data/storages/card.dart';
import 'package:everylounge/domain/entities/bank/bin.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CardStorageImpl implements CardStorage {
  static const String boxName = 'cards';

  static Future initHive() {
    return Hive.openBox(boxName);
  }

  @override
  List<Bin>? get bins {
    final List? list = _hiveBox.get(_Keys.bins.name);
    if (list == null) return null;
    return list.map<Bin>((e) {
      return Bin.fromJson(e);
    }).toList();
  }

  @override
  set bins(List<Bin>? value) {
    _hiveBox.put(_Keys.bins.name, value?.map((e) => e.toMap()).toList());
  }

  @override
  List<BankCard>? get cards {
    final List? list = _hiveBox.get(_Keys.cards.name);
    if (list == null) return null;
    return list.map<BankCard>((e) => BankCard.fromJson(e)).toList();
  }

  @override
  set cards(List<BankCard>? value) {
    _hiveBox.put(_Keys.cards.name, value?.map((e) => e.toMap()).toList());
  }

  final _hiveBox = Hive.box(boxName);
}

enum _Keys { bins, cards }
