import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/feedback.dart';
import 'package:everylounge/domain/entities/feedback/faq.dart';

class FeedbackApiImpl implements FeedbackApi {
  final Dio _client = getIt();

  @override
  Future<bool> postFeedback({
    required String? name,
    required String? email,
    required String? text,
  }) async {
    final response = await _client.post(
      'feedback',
      data: {'name': name, 'email': email, 'text': text},
    );
    return response.data["code"] == 200;
  }

  @override
  Future<List<Faq>> getFaq() async {
    final response = await _client.get("faq");
    final data = (response.data as Map<String, dynamic>)['data'];
    final list = data.map((e) => Faq.fromJson(e as Map<String, dynamic>)).toList();
    return List<Faq>.from(list);
  }
}
