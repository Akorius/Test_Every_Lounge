import 'dart:async';

import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/login.dart';
import 'package:everylounge/domain/entities/auth_provider.dart';
import 'package:everylounge/domain/entities/login/tinkoff_id_web_token_payload.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/login/user.dart';

///Содержит запросы связаные с авторизацией и регистрацией
class LoginApiImpl implements LoginApi {
  final Dio _client = getIt();

  @override
  Future<EveryLoungeToken> social({
    required AuthProvider provider,
    String? socialToken,
  }) async {
    final result = await _client.post(
      'auth/login',
      data: {
        "provider": provider.index,
        if (socialToken != null) "token": socialToken,
      },
    );
    return EveryLoungeToken.fromJson(result.data["data"]);
  }

  @override
  Future<bool> sendEmail({
    String? email,
  }) async {
    final result = await _client.post(
      'auth/login',
      data: {
        "provider": AuthProvider.email.index,
        if (email != null) "email": email,
      },
    );

    return result.data["code"] == "200";
  }

  @override
  Future<EveryLoungeToken> sendCode({
    String? code,
    String? email,
  }) async {
    final result = await _client.post(
      'auth/login',
      data: {
        "provider": AuthProvider.email.index,
        if (code != null) "code": code,
        if (email != null) "email": email,
      },
    );

    return EveryLoungeToken.fromJson(result.data["data"]);
  }

  @override
  Future<User> userMe() async {
    final result = await _client.get('users/me');
    return User.fromJson(result.data["data"]);
  }

  @override
  Future<void> updateMe(String? phone, String? firstName, String? lastName, int? avatarId, int? rateFlag) async {
    final formData = FormData.fromMap({
      if (phone != null) "phone": phone,
      if (firstName != null) "first_name": firstName.trim(),
      if (lastName != null) "last_name": lastName.trim(),
      if (avatarId != null) "attach_id": avatarId,
      if (rateFlag != null) "rate_flag": rateFlag,
    });
    await _client.put(
      'users/update',
      data: formData,
    );
  }

  @override
  Future<bool> changeEmail({required String email}) async {
    final response = await _client.post(
      'users/change-email',
      data: FormData.fromMap({
        "email": email,
      }),
    );
    return response.data["code"] == 200;
  }

  @override
  Future<bool> changeEmailCode({required String email, required String code}) async {
    final response = await _client.post(
      'users/change-email',
      data: FormData.fromMap({"email": email, "code": code}),
    );
    return response.data["code"] == 200;
  }

  @override
  Future<void> deleteProfile({required String? email, String? code}) async {
    await _client.delete(
      'users/delete',
      data: {
        "email": email,
        "code": code,
      },
    );
  }

  @override
  Future<EveryLoungeToken> oldUserLogin(String oldAccessToken) async {
    final response = await _client.post("auth/old/$oldAccessToken");
    return EveryLoungeToken.fromJson(response.data["data"]);
  }

  @override
  Future<void> updateTinkoffUser(String tinkoffAccessToken) async {
    await _client.post("users/update-tinkoff",
        data: FormData.fromMap({
          "token": tinkoffAccessToken,
        }));
  }

  @override
  Future<User> addTinkoffIdToUser(String tinkoffAccessToken) async {
    final result = await _client.post("users/add-tinkoff", data: {
      "token": tinkoffAccessToken,
    });
    return User.fromJson(result.data["data"]);
  }

  @override
  Future<TinkoffIdWebTokenPayload> changeCodeForTinkoffTokenWeb({required String code}) async {
    final response = await _client.post(
      "users/auth-tinkoff",
      data: {
        "code": code,
      },
    );
    return TinkoffIdWebTokenPayload.fromJson(response.data["data"]);
  }

  @override
  Future<String> getAlfaAuthLink() async {
    final response = await _client.get("auth/alfa-auth-url");
    return response.data["data"];
  }
}
