class Schedule {
  final String validFromTime;
  final String validTillTime;
  final List<String> validDays;

  Schedule(this.validFromTime, this.validTillTime, this.validDays);

  factory Schedule.fromJson(Map<dynamic, dynamic> json) => Schedule(
        json['valid_from_time'] as String,
        json['valid_till_time'] as String,
        (json['valid_days'] as List<dynamic>).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'valid_from_time': validFromTime,
      'valid_till_time': validTillTime,
      'valid_days': validDays,
    };
  }
}
