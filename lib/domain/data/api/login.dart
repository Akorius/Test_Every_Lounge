import 'package:everylounge/domain/entities/auth_provider.dart';
import 'package:everylounge/domain/entities/login/tinkoff_id_web_token_payload.dart';
import 'package:everylounge/domain/entities/login/tokens_payload.dart';
import 'package:everylounge/domain/entities/login/user.dart';

abstract class LoginApi {
  Future<EveryLoungeToken> social({
    required AuthProvider provider,
    String? socialToken,
  });

  Future<bool> sendEmail({
    String? email,
  });

  Future<EveryLoungeToken> sendCode({
    String? code,
    String? email,
  });

  Future<User> userMe();

  Future<void> updateMe(String? phone, String? firstName, String? lastName, int? avatarId, int? rateFlag);

  Future<bool> changeEmail({required String email});

  Future<bool> changeEmailCode({required String email, required String code});

  Future<void> deleteProfile({required String? email, required String? code});

  Future<EveryLoungeToken> oldUserLogin(String oldAccessToken);

  Future<void> updateTinkoffUser(String tinkoffAccessToken);

  Future<User> addTinkoffIdToUser(String tinkoffAccessToken);

  Future<TinkoffIdWebTokenPayload> changeCodeForTinkoffTokenWeb({required String code});

  Future<String> getAlfaAuthLink();
}
