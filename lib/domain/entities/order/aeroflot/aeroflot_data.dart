import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_leg.dart';

class AeroflotData {
  AeroflotData({
    required this.legs,
  });

  final List<AeroflotLeg>? legs;

  factory AeroflotData.fromJson(Map<dynamic, dynamic> json) => AeroflotData(
        legs: json['legs'] != null ? List.from(json['legs']).map((e) => AeroflotLeg.fromJson(e)).toList() : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'legs': legs?.map((aeroflotLegs) => aeroflotLegs.toJson()).toList(),
    };
  }
}
