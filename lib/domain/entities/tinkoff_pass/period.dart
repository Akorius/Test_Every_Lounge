class Period {
  final String? validFrom;
  final String? validUntil;
  final String? repeatability;

  Period({
    this.validFrom,
    this.validUntil,
    this.repeatability,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      validFrom: json['validFrom'],
      validUntil: json['validUntil'],
      repeatability: json['repeatability'],
    );
  }
}
