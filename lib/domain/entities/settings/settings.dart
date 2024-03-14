class AppSettings {
  AppSettings({
    required this.actualAppVersion,
    required this.actualRulesId,
    required this.actualOfferId,
    required this.actualPolicyId,
    this.body,
    this.prompt,
    this.title,
    this.buttonTitleIgnore,
    this.buttonTitleLater,
    this.buttonTitleUpdate,
    this.releaseNotes,
    required this.isRequired,
  });

  final String actualAppVersion;
  final String? actualRulesId;
  final String? actualOfferId;
  final String? actualPolicyId;
  final String? body;
  final String? prompt;
  final String? title;
  final String? buttonTitleIgnore;
  final String? buttonTitleLater;
  final String? buttonTitleUpdate;
  final String? releaseNotes;
  final bool isRequired;

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        actualAppVersion: json["actual_app_version"] as String,
        body: json["body"] as String?,
        prompt: json["prompt"] as String?,
        title: json["title"] as String?,
        buttonTitleIgnore: json["button_title_ignore"] as String?,
        buttonTitleLater: json["button_title_later"] as String?,
        buttonTitleUpdate: json["button_title_update"] as String?,
        actualRulesId: json["actual_rules_id"] as String,
        actualOfferId: json["actual_offer_id"] as String,
        actualPolicyId: json["actual_policy_id"] as String,
        releaseNotes: json["release_notes"] as String?,
        isRequired: json["is_required"] as bool,
      );

  Map<String, dynamic> toJson() {
    return {
      'actual_app_version': actualAppVersion,
      'body': body,
      'prompt': prompt,
      'title': title,
      'button_title_ignore': buttonTitleIgnore,
      'button_title_later': buttonTitleLater,
      'button_title_update': buttonTitleUpdate,
      'actual_rules_id': actualRulesId,
      'actual_offer_id': actualOfferId,
      'actual_policy_id': actualPolicyId,
      'release_notes': releaseNotes,
      'is_required': isRequired,
    };
  }
}
