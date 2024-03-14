import 'package:everylounge/domain/entities/order/passengers.dart';

class PassageCheckInfo {
  final int loungeId;
  final List<Passengers> passengers;

  PassageCheckInfo({
    required this.loungeId,
    required this.passengers,
  });

  factory PassageCheckInfo.fromJson(Map<dynamic, dynamic> json) => PassageCheckInfo(
        loungeId: json['loungeId'] as int,
        passengers: json['passengers'] as List<Passengers>,
      );

  Map<String, dynamic> toJson() {
    return {
      'loungeId': loungeId,
      'passengers': passengers,
    };
  }
}
