import 'faq_type.dart';

class Faq {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String question;
  final String answer;
  final int order;
  final FaqType type;
  final bool displayInWeb;
  final bool displayInApp;

  Faq({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.question,
    required this.answer,
    required this.order,
    required this.type,
    required this.displayInWeb,
    required this.displayInApp,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        question: json["question"],
        answer: json["answer"],
        order: json["order"],
        type: FaqTypeExt.fromInt(json["type"] ?? 0),
        displayInWeb: json["display_in_web"] ?? true,
        displayInApp: json["display_in_app"] ?? true,
      );
}
