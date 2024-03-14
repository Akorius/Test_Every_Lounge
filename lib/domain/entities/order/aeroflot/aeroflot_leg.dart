import 'package:everylounge/domain/entities/order/aeroflot/aeroflot_segment.dart';

class AeroflotLeg {
  AeroflotLeg({
    required this.segments,
  });

  final List<AeroflotSegment> segments;

  factory AeroflotLeg.fromJson(Map<dynamic, dynamic> json) => AeroflotLeg(
        segments: json['segments'] == null ? [] : List.from(json['segments']).map((e) => AeroflotSegment.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'segments': segments.map((aeroflotSegment) => aeroflotSegment.toJson()).toList(),
    };
  }
}
