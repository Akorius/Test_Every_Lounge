import 'package:everylounge/domain/data/storages/developer_mode.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeveloperModeStorageImpl implements DeveloperModeStorage {
  static Future initHive() {
    return Hive.openBox(_boxName);
  }

  @override
  bool get enabled => _hiveBox.get(_Keys.enabled.name, defaultValue: false);

  @override
  set enabled(bool value) => _hiveBox.put(_Keys.enabled.name, value);

  @override
  bool get payWithOneRuble => _hiveBox.get(_Keys.payWithOneRuble.name, defaultValue: false);

  @override
  set payWithOneRuble(bool value) => _hiveBox.put(_Keys.payWithOneRuble.name, value);

  static const String _boxName = 'developerMode';
  final _hiveBox = Hive.box(_boxName);
}

enum _Keys {
  enabled,
  payWithOneRuble,
}
