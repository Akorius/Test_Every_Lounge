import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/alfa/alfa_id.dart';
import 'package:everylounge/domain/entities/login/user.dart';

class AlfaIdApiImpl implements AlfaIdApi {
  final Dio _client = getIt();

  @override
  Future<User> addAlfaIdToUser(String accessToken) async {
    final result = await _client.post("users/add-alfa", data: {
      "token": accessToken,
    });
    return User.fromJson(result.data["data"]);
  }
}
