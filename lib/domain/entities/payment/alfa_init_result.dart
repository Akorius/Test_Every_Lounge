class AlfaInitResult {
  final String transactionId;
  final String redirect;

  AlfaInitResult({required this.transactionId, required this.redirect});

  factory AlfaInitResult.fromJson(Map<String, dynamic> json) {
    return AlfaInitResult(
      transactionId: json['order_id'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }
}
