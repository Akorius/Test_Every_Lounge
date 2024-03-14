class PassageCheck {
  final bool passagePayAvailable;
  final int passengersAvailableCount;

  PassageCheck({
    required this.passagePayAvailable,
    required this.passengersAvailableCount,
  });

  factory PassageCheck.fromJson(Map<dynamic, dynamic> json) => PassageCheck(
        passagePayAvailable: json['passage_pay_available'] as bool,
        passengersAvailableCount: json['passengers_available_count'] as int,
      );

  Map<String, dynamic> toJson() {
    return {
      'passage_pay_available': passagePayAvailable,
      'passengers_available_count': passengersAvailableCount,
    };
  }

  PassageCheck.mock({bool? passagePayAvailable, int? passengersAvailableCount})
      : this(passagePayAvailable: passagePayAvailable ?? true, passengersAvailableCount: passengersAvailableCount ?? 0);
}
