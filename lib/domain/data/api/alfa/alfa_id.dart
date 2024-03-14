import 'package:everylounge/domain/entities/login/user.dart';

abstract class AlfaIdApi {
  Future<User> addAlfaIdToUser(String accessToken);
}
