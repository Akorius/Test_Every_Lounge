class Point {
  final num lng;
  final num lat;

  Point({
    required this.lng,
    required this.lat,
  });

  factory Point.fromJson(Map<dynamic, dynamic> json) => Point(
        lng: json['lng'] as num,
        lat: json['lat'] as num,
      );

  Map<String, dynamic> toJson() {
    return {
      'lng': lng,
      'lat': lat,
    };
  }
}
