class Dob {
  String time;
  bool valid;

  Dob({
    required this.time,
    required this.valid,
  });

  Dob.fromJson(Map<dynamic, dynamic> json)
      : time = json['Time'],
        valid = json['Valid'];

  Map<String, dynamic> toJson() {
    return {
      'Time': time,
      'Valid': valid,
    };
  }

  @override
  String toString() {
    return 'Dob{time: $time, valid: $valid}';
  }
}
