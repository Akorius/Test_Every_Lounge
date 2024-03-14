import 'package:everylounge/domain/data/storages/old_tokens.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'auth.dart';

class OldTokensStorageImpl implements OldTokensStorage {
  static const String boxName = 'auth';

  static Future initHive() async {
    Hive.registerAdapter(AnonStatusRequestingAdapter());
    await Hive.openBox(boxName);
  }

  Box get _hiveBox => Hive.box(boxName);

  @override
  String? get accessToken => _hiveBox.get(_Keys.token.toString());

  @override
  set accessToken(String? value) => _hiveBox.put(_Keys.token.toString(), value);

  @override
  String? get tinkoffRefreshToken => _hiveBox.get(_Keys.tinkoffRefreshToken.toString());

  @override
  set tinkoffRefreshToken(String? value) => _hiveBox.put(_Keys.tinkoffRefreshToken.toString(), value);
}

enum _Keys {
  token,
  tinkoffRefreshToken,
}
