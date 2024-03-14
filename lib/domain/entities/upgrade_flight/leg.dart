import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';

class Leg {
  Leg({
    required this.segments,
  });

  final List<Segment> segments;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        segments: List.from(json['segments']).map((e) => Segment.fromJson(e)).toList(),
      );
}
