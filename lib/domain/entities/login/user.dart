import 'package:everylounge/domain/entities/bank/bank.dart';

import 'auth_type.dart';
import 'passage.dart';
import 'profile.dart';

class User {
  final int id;
  final String createdAt;
  final String updatedAt;
  final Profile profile;
  final String email;
  final bool first;
  final ActiveBank activeBank;
  final ActiveBankStatus? activeBankStatus;
  final ActiveBankStatus? tinkoffBankStatus;
  final ActiveBankStatus? alfaBankStatus;
  final int? platform;
  final String? appVersion;
  final bool locationEnabled;
  final int showRate;
  final AuthType authType;
  final String? tinkoffId;
  final String? alfaId;
  final String? delReason;
  final int? activeBankPassesCount;
  final List<Passage>? passages;
  final Passage? activePassage;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
    required this.email,
    required this.first,
    required this.activeBank,
    required this.activeBankStatus,
    required this.tinkoffBankStatus,
    required this.alfaBankStatus,
    required this.platform,
    required this.appVersion,
    required this.locationEnabled,
    required this.showRate,
    required this.authType,
    required this.tinkoffId,
    required this.alfaId,
    required this.delReason,
    required this.activeBankPassesCount,
    required this.passages,
    required this.activePassage,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        id: json['id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        profile: Profile.fromJson(json['profile']),
        email: json['email'],
        first: json['first'],
        activeBank: ActiveBankExtension.fromInt(json['active_bank']),
        activeBankStatus: ActiveBankStatusExtension.fromInt(json['active_bank_status']),
        tinkoffBankStatus: ActiveBankStatusExtension.fromInt(json["tinkoff_status"]),
        alfaBankStatus: ActiveBankStatusExtension.fromInt(json["alfa_status"]),
        platform: json['platform'] as int?,
        appVersion: json['app_version'],
        locationEnabled: json['location_enabled'],
        showRate: json['show_rate'],
        authType: AuthTypeExt.fromInt(json['auth_type']),
        tinkoffId: json['tinkoff_id'],
        alfaId: json['alfa_id'],
        delReason: json['del_reason'],
        activeBankPassesCount: json['active_entry_count'],
        passages: (json["passages"] as List?)?.map((e) => Passage.fromJson(e)).toList(),
        activePassage: json["active_passage"] != null ? Passage.fromJson(json["active_passage"]) : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile': profile.toJson(),
      'email': email,
      'first': first,
      'active_bank': activeBank.index,
      'active_bank_status': activeBankStatus?.index,
      'tinkoff_status': tinkoffBankStatus?.index,
      'alfa_status': alfaBankStatus?.index,
      'platform': platform,
      'app_version': appVersion,
      'location_enabled': locationEnabled,
      'show_rate': showRate,
      'auth_type': authType.index,
      'tinkoff_id': tinkoffId,
      'alfa_id': alfaId,
      'del_reason': delReason,
      'active_entry_count': activeBankPassesCount,
      'passages': passages?.map((e) => e.toJson()).toList(),
      'active_passage': activePassage?.toJson(),
    };
  }

  @override
  String toString() {
    return 'User{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, profile: $profile, email: $email, first: $first, activeBank: $activeBank, activeBankStatus: $activeBankStatus, tinkoffBankStatus: $tinkoffBankStatus, alfaBankStatus : $alfaBankStatus, platform: $platform, appVersion: $appVersion, locationEnabled: $locationEnabled, showRate: $showRate, authType: $authType, tinkoffId: $tinkoffId, delReason: $delReason}';
  }

  User copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    Profile? profile,
    String? email,
    bool? first,
    ActiveBank? activeBank,
    ActiveBankStatus? activeBankStatus,
    ActiveBankStatus? tinkoffBankStatus,
    ActiveBankStatus? alfaBankStatus,
    int? platform,
    String? appVersion,
    bool? locationEnabled,
    int? showRate,
    AuthType? authType,
    String? tinkoffId,
    String? alfaId,
    String? delReason,
    int? activeBankPassesCount,
    List<Passage>? passages,
    Passage? activePassage,
  }) {
    return User(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profile: profile ?? this.profile,
      email: email ?? this.email,
      first: first ?? this.first,
      activeBank: activeBank ?? this.activeBank,
      activeBankStatus: activeBankStatus ?? this.activeBankStatus,
      tinkoffBankStatus: tinkoffBankStatus ?? this.tinkoffBankStatus,
      alfaBankStatus: alfaBankStatus ?? this.alfaBankStatus,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      showRate: showRate ?? this.showRate,
      authType: authType ?? this.authType,
      tinkoffId: tinkoffId ?? this.tinkoffId,
      alfaId: alfaId ?? this.alfaId,
      delReason: delReason ?? this.delReason,
      activeBankPassesCount: activeBankPassesCount ?? this.activeBankPassesCount,
      passages: passages ?? this.passages,
      activePassage: activePassage ?? this.activePassage,
    );
  }

  factory User.mock() {
    return User(
      id: 0,
      createdAt: '',
      updatedAt: '',
      profile: Profile(
          id: 0,
          createdAt: '',
          updatedAt: '',
          userId: 0,
          firstName: '',
          middleName: '',
          lastName: '',
          avatar: 0,
          phone: '',
          gender: 0,
          dob: null),
      email: '',
      first: true,
      activeBank: ActiveBank.none,
      activeBankStatus: null,
      tinkoffBankStatus: null,
      alfaBankStatus: null,
      platform: null,
      appVersion: '',
      locationEnabled: true,
      showRate: 0,
      authType: AuthType.email,
      tinkoffId: '',
      alfaId: '',
      delReason: '',
      activeBankPassesCount: null,
      passages: [],
      activePassage: null,
    );
  }
}
