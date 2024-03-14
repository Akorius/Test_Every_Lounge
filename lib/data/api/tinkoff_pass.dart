import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/tinkoff_api_client.dart';
import 'package:everylounge/domain/data/api/tinkoff_pass.dart';
import 'package:everylounge/domain/entities/tinkoff_pass/tinkoff_passage.dart';

class TinkoffPassApiImpl implements TinkoffPassApi {
  @override
  Future<TinkoffPassage> getPassageInfo(String accessToken) async {
    final Dio _client = getIt<TinkoffApiClient>().create(accessToken);

    final response = await _client.get(
      'openapi/api/v1/individual/detail-counters',
    );
    return TinkoffPassage.fromJson(response.data);
  }
}
