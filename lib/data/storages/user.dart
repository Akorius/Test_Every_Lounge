import 'package:everylounge/domain/data/storages/user.dart';
import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserStorageImpl implements UserStorage {
  static const String _boxName = 'UserStorage1';

  static Future initHive() async {
    return Hive.openBox(_boxName);
  }

  @override
  User? get user {
    final Map<dynamic, dynamic>? json = _hiveBox.get(_Keys.user.name, defaultValue: null);
    if (json == null) {
      return null;
    } else {
      return User.fromJson(json);
    }
  }

  @override
  set user(User? value) {
    _hiveBox.put(_Keys.user.name, value?.toJson());
  }

  @override
  int get id => user!.id;

  @override
  String get email => user!.email;

  @override
  ActiveBankStatus? get activeBankStatus => user?.activeBankStatus;

  @override
  ActiveBankStatus? get tinkoffBankStatus => user?.tinkoffBankStatus;

  @override
  ActiveBankStatus? get alfaBankStatus => user?.alfaBankStatus;

  @override
  AuthType get authType => user?.authType ?? AuthType.anon;

  @override
  String? get tinkoffId => user?.tinkoffId;

  @override
  String? get alfaId => user?.alfaId;

  @override
  String? get phone => user?.profile.phone;

  @override
  List<Passage> get passages => user?.passages ?? [];

  @override
  Passage? get activePassage => user?.activePassage;

  final _hiveBox = Hive.box(_boxName);
}

enum _Keys {
  user,
}
