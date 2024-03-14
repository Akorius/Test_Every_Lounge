import 'dart:convert';

import 'package:everylounge/domain/data/storages/settings.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/settings/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsStorageImpl implements SettingsStorage {
  static const String _boxName = 'SettingsStorage';

  static Future initHive() async {
    return Hive.openBox<String?>(_boxName);
  }

  @override
  AppSettings? get settings {
    var body = _hiveBox.get(_Keys.settings.name) ?? '';
    return body.isNotEmpty ? AppSettings.fromJson(jsonDecode(body)) : null;
  }

  @override
  set settings(AppSettings? value) {
    try {
      if (value != null) {
        _hiveBox.put(_Keys.settings.name, jsonEncode(value.toJson()));
      }
    } catch (e, s) {
      Log.exception(e, s, "SettingsStorageImpl");
    }
  }

  @override
  void clear() {
    _hiveBox.clear();
  }

  final _hiveBox = Hive.box<String?>(_boxName);
}

enum _Keys {
  settings,
}
