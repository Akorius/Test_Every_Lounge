import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/login/auth_type.dart';
import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/domain/entities/login/user.dart';

abstract class UserStorage {
  late final User? user;

  int get id;

  String get email;

  ActiveBankStatus? get activeBankStatus;

  ActiveBankStatus? get tinkoffBankStatus;

  ActiveBankStatus? get alfaBankStatus;

  AuthType get authType;

  String? get tinkoffId;

  String? get alfaId;

  String? get phone;

  List<Passage> get passages;

  Passage? get activePassage;
}
