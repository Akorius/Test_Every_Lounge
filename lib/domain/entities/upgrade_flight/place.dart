class Place {
  Place({
    required this.airportCode,
    required this.airportName,
    required this.cityCode,
    required this.cityName,
  });

  final String airportCode;
  final String airportName;
  final String cityCode;
  final String cityName;

  factory Place.fromJson(Map<dynamic, dynamic> json) => Place(
        airportCode: json['airport_code'],
        airportName: json['airport_name'],
        cityCode: json['city_code'],
        cityName: json['city_name'],
      );

  Map<String, dynamic> toJson() {
    return {
      'airport_code': airportCode,
      'airport_name': airportName,
      'city_code': cityCode,
      'city_name': cityName,
    };
  }
}
