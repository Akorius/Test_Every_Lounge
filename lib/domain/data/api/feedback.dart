import 'package:everylounge/domain/entities/feedback/faq.dart';

abstract class FeedbackApi {
  Future<bool> postFeedback({
    required String? name,
    required String? email,
    required String? text,
  });

  Future<List<Faq>> getFaq();
}
