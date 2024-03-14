import 'dart:convert';

import 'package:everylounge/domain/data/storages/update.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpdateStorageImpl implements UpdateStorage {
  static const String _boxName = 'UpdateStorage';

  static Future initHive() async {
    return Hive.openBox<String?>(_boxName);
  }

  List<String> get deferredUpdateVersionList {
    var body = _hiveBox.get(_Keys.deferredUpdateVersion.name) ?? '';
    return body.isNotEmpty ? List<String>.from(jsonDecode(body)) : [];
  }

  final _hiveBox = Hive.box<String?>(_boxName);

  @override
  void addAppVersion(String currentVersion) {
    var list = deferredUpdateVersionList;
    if (list.contains(currentVersion) == false) {
      list.add(currentVersion);
      try {
        _hiveBox.put(_Keys.deferredUpdateVersion.name, jsonEncode(list));
      } catch (error, stackTrace) {
        Log.exception(error, stackTrace, "SettingsStorageImpl addDeferredVersion");
      }
    }
  }

  @override
  bool needShowUpdate(String currentVersion) {
    return deferredUpdateVersionList.contains(currentVersion) == false;
  }
}

enum _Keys {
  deferredUpdateVersion,
}
