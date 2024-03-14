import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokensStorageImpl implements TokensStorage {
  static const String _boxName = 'TokensStorage';

  static Future initHive() async {
    return Hive.openBox<String?>(_boxName);
  }

  @override
  String? get accessToken => _hiveBox.get(_Keys.accessToken.name);

  @override
  set accessToken(String? value) => _hiveBox.put(_Keys.accessToken.name, value);

  @override
  String? get refreshToken => _hiveBox.get(_Keys.refreshToken.name);

  @override
  set refreshToken(String? value) => _hiveBox.put(_Keys.refreshToken.name, value);

  @override
  String? get tinkoffAccessToken => _hiveBox.get(_Keys.tinkoffAccessToken.name);

  @override
  String? get tinkoffRefreshToken => _hiveBox.get(_Keys.tinkoffRefreshToken.name);

  @override
  set tinkoffAccessToken(String? value) => _hiveBox.put(_Keys.tinkoffAccessToken.name, value);

  @override
  set tinkoffRefreshToken(String? value) => _hiveBox.put(_Keys.tinkoffRefreshToken.name, value);

  @override
  String? get alfaRefreshToken => _hiveBox.get(_Keys.alfaRefreshToken.name);

  @override
  set alfaRefreshToken(String? value) => _hiveBox.put(_Keys.alfaRefreshToken.name, value);

  @override
  Future<void> deleteTokens() async {
    await _hiveBox.deleteAll([
      _Keys.accessToken.name,
      _Keys.refreshToken.name,
      _Keys.tinkoffAccessToken.name,
      _Keys.tinkoffRefreshToken.name,
      _Keys.alfaRefreshToken.name,
    ]);
  }

  final _hiveBox = Hive.box<String?>(_boxName);
}

enum _Keys {
  accessToken,
  refreshToken,
  tinkoffAccessToken,
  tinkoffRefreshToken,
  alfaRefreshToken,
}
