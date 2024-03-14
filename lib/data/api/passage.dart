import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/passage.dart';

class PassageApiImpl implements PassageApi {
  final Dio _client = getIt();

  @override
  Future<void> removePassage({required int id}) async {
    await _client.delete("passages/$id");
  }
}
