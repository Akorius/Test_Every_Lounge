import 'package:everylounge/domain/entities/bank/bank.dart';

class Passage {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String phoneNumber;
  final int? entryCount;
  final TypePassage type;
  final int? resetEntryCount;
  final String? firstName;
  final String? middleName; // не приходит
  final String? lastName;
  final DateTime? expiresAt;
  final ActiveBank bank;

  Passage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNumber,
    required this.entryCount,
    required this.type,
    required this.resetEntryCount,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.expiresAt,
    required this.bank,
  });

  Passage.mock()
      : id = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        expiresAt = DateTime.now(),
        phoneNumber = "79897003489",
        entryCount = 5,
        type = TypePassage.automaticZeroing,
        resetEntryCount = 0,
        firstName = 'Google',
        middleName = 'Maksimov',
        lastName = 'Yandexovich',
        bank = ActiveBank.alfa;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'phone_number': phoneNumber,
      'entry_count': entryCount,
      'type': type.index,
      'reset_entry_count': resetEntryCount,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'expires_at': expiresAt.toString(),
      'bank': bank.index,
    };
  }

  factory Passage.fromJson(Map<dynamic, dynamic> json) {
    return Passage(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      phoneNumber: json['phone_number'] as String,
      entryCount: json['entry_count'] as int,
      type: TypePassageExtension.fromInt((json['type'] as int?) ?? 0),
      resetEntryCount: json['reset_entry_count'] as int?,
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      expiresAt: DateTime.tryParse((json['expires_at'] as String?) ?? ''),
      bank: ActiveBankExtension.fromInt(json['bank'] as int),
    );
  }

  bool get isLimitedPasses => type == TypePassage.automaticZeroing || type == TypePassage.calculatedByActive;

  bool get isUnlimitedPasses => type == TypePassage.endlessLounge || type == TypePassage.endlessLoungeAndUpgrade;

  bool canPayByPass() {
    return (((entryCount ?? 0) > 0 && isLimitedPasses == true) || isUnlimitedPasses == true);
  }
}

enum TypePassage {
  calculatedByActive, // 0 - проходы вычисляются по active_entry_count
  automaticZeroing, // 1 - автоматическое обнуление проходов
  endlessLounge, // 2 - бесконечные проходы в залы
  endlessLoungeAndUpgrade, // 3 - бесконечные проходы в залы и апгрейды
}

extension TypePassageExtension on TypePassage {
  static TypePassage fromInt(int? number) {
    switch (number ?? 0) {
      case 1:
        return TypePassage.automaticZeroing;
      case 2:
        return TypePassage.endlessLounge;
      case 3:
        return TypePassage.endlessLoungeAndUpgrade;
      case 0:
      default:
        return TypePassage.calculatedByActive;
    }
  }
}
