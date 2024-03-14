import 'package:everylounge/domain/entities/bank/bank.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/login/passage.dart';

import 'card_type.dart';

class BankCard {
  late final int id;
  final String createdAt;
  final String updatedAt;
  late final String sdkId;
  final String maskedNumber;
  final bool isActive;
  late final BankCardType type;
  final int selfPasses;
  final int guestPasses;
  final int rebillId;
  final bool? fake;
  final int? passesCount;
  TypePassage? passageType;

  BankCard({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.sdkId,
    required this.maskedNumber,
    required this.isActive,
    required this.type,
    required this.selfPasses,
    required this.guestPasses,
    required this.rebillId,
    this.fake = false,
    this.passesCount,
    this.passageType,
  });

  BankCard.mock()
      : id = 0,
        createdAt = "",
        updatedAt = "",
        sdkId = "0",
        maskedNumber = "**** **** **** 4446",
        selfPasses = 0,
        guestPasses = 0,
        rebillId = 0,
        fake = false,
        isActive = true,
        type = BankCardType.alfaClub,
        passesCount = 10;

  BankCard.tinkoffFakeFromProfile(ActiveBankStatus status, this.isActive, int? count)
      : id = ActiveBank.tinkoff.index,
        createdAt = "",
        updatedAt = "",
        sdkId = ActiveBank.tinkoff.index.toString(),
        maskedNumber = "**** **** **** **id",
        selfPasses = 0,
        guestPasses = 0,
        rebillId = 0,
        fake = true,
        passesCount = count {
    switch (status) {
      case ActiveBankStatus.standard:
        type = BankCardType.tinkoffDefault;
        break;
      case ActiveBankStatus.premium:
        type = BankCardType.tinkoffPremium;
        break;
      case ActiveBankStatus.private:
        type = BankCardType.tinkoffPrivate;
        break;
      case ActiveBankStatus.pro:
        type = BankCardType.tinkoffPro;
        break;
      case ActiveBankStatus.alfaClub:
      default:
        type = BankCardType.tinkoffDefault;
        break;
    }
  }

  BankCard.alfaFakeFromProfile(ActiveBankStatus status, this.isActive)
      : id = ActiveBank.alfa.index,
        createdAt = "",
        updatedAt = "",
        sdkId = ActiveBank.alfa.index.toString(),
        maskedNumber = "**** **** **** **id",
        selfPasses = 0,
        guestPasses = 0,
        rebillId = 0,
        fake = true,
        passesCount = null {
    type = BankCardType.alfaPrem;
  }

  BankCard.phoneFakeFromProfile(Passage passage, this.isActive)
      : createdAt = passage.createdAt.toString(),
        updatedAt = passage.updatedAt.toString(),
        maskedNumber = "**** **** **** ****",
        selfPasses = 0,
        guestPasses = 0,
        rebillId = 0,
        fake = true,
        passageType = passage.type,
        passesCount = passage.isUnlimitedPasses ? -1 : (passage.entryCount ?? 0) {
    switch (passage.bank) {
      case ActiveBank.none:
      case ActiveBank.tinkoff:
      case ActiveBank.gazprom:
      case ActiveBank.sber:
      case ActiveBank.moscowCredit:
      case ActiveBank.otkrytie:
      case ActiveBank.raiffeisen:
        type = BankCardType.other;
        id = 0;
        sdkId = "0";
        Log.exception(Exception("Недопустимое значение банка: ${passage.bank}"));
        break;
      case ActiveBank.alfa:
        id = passage.id;
        sdkId = passage.bank.index.toString();
        type = BankCardType.alfaClub;
        break;
      case ActiveBank.tochka:
        id = passage.id;
        sdkId = passage.bank.index.toString();
        type = BankCardType.tochka;
        break;
      case ActiveBank.beelineKZ:
        id = passage.id;
        sdkId = passage.bank.index.toString();
        type = BankCardType.beelineKZ;
        break;
    }
  }

  bool get cardForPaymentByPasses =>
      fake == true &&
      (bankForPaymentByPassesWithoutTinkoff(ActiveBankExtension.fromInt(getIndexByActiveCard(type))) || availableTinkoffPasses) &&
      type != BankCardType.alfaPrem;

  bool get cardTinkoffByPasses =>
      type == BankCardType.tinkoffPremium ||
      type == BankCardType.tinkoffPrivate ||
      type == BankCardType.tinkoffPro ||
      type == BankCardType.tinkoffDefault;

  bool get availableTinkoffPasses => cardTinkoffByPasses && passesCount != null && passesCount != 0;

  factory BankCard.fromJson(Map<dynamic, dynamic> json) => BankCard(
        id: json['id'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        sdkId: json['sdk_id'] as String,
        maskedNumber: json['masked_number'] as String,
        isActive: json['is_active'] as bool,
        type: bankCardTypeFromInt(json['type'] as int),
        selfPasses: json['self_passes'] as int,
        guestPasses: json['guest_passes'] as int,
        rebillId: json['rebill_id'] as int,
        fake: json['fake'] as bool?,
        passesCount: json['passes_count'] as int?,
        passageType: TypePassageExtension.fromInt((json['passage_type'] as int?) ?? 0),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sdk_id': sdkId,
      'masked_number': maskedNumber,
      'is_active': isActive,
      'type': type.index,
      'self_passes': selfPasses,
      'guest_passes': guestPasses,
      'rebill_id': rebillId,
      "fake": fake,
      "passes_count": passesCount,
      "passage_type": passageType?.index,
    };
  }

  @override
  String toString() {
    return 'BankCard{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, sdkId: $sdkId, maskedNumber: $maskedNumber, isActive: $isActive, type: $type, selfPasses: $selfPasses, guestPasses: $guestPasses, rebillId: $rebillId, fake: $fake}';
  }

  BankCard copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? sdkId,
    String? maskedNumber,
    bool? isActive,
    BankCardType? type,
    int? selfPasses,
    int? guestPasses,
    int? rebillId,
    bool? fake,
    int? passesCount,
    TypePassage? passageType,
  }) {
    return BankCard(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sdkId: sdkId ?? this.sdkId,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      selfPasses: selfPasses ?? this.selfPasses,
      guestPasses: guestPasses ?? this.guestPasses,
      rebillId: rebillId ?? this.rebillId,
      fake: fake ?? this.fake,
      passesCount: passesCount ?? this.passesCount,
      passageType: passageType ?? this.passageType,
    );
  }
}
