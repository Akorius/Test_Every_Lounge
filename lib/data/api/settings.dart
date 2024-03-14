import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/data/api/settings.dart';
import 'package:everylounge/domain/data/storages/tokens.dart';
import 'package:everylounge/domain/entities/settings/settings.dart';
import 'package:logger/logger.dart';

class AppSettingsApiImpl implements AppSettingsApi {
  final Dio _client = getIt();
  final TokensStorage _tokenStorage = getIt();

  @override
  Future<AppSettings> getSettings() async {
    final response = await _client.get(
      "${ApiClient.baseUrl}settings",
      options: Options(headers: {"Authorization": "Bearer ${_tokenStorage.accessToken}"}),
    );
    Logger().log(Level.debug, response.data);
    return AppSettings.fromJson(response.data['data']);
  }
}
