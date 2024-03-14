class ClientInfo {
  final String? grade;
  final bool? isFulfillConditions;

  ClientInfo({
    this.grade,
    this.isFulfillConditions,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) {
    return ClientInfo(
      grade: json['grade'],
      isFulfillConditions: json['isFulfillConditions'],
    );
  }
}
