class Rule {
  final String? name;
  final int? minSize;

  Rule({
    this.name,
    this.minSize,
  });

  factory Rule.fromJson(Map<dynamic, dynamic> json) => Rule(
        name: json['name'] as String?,
        minSize: json['min_size'] as int?,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'minSize': minSize,
    };
  }

  factory Rule.mock() => Rule(
        name: 'GroupRateRule',
        minSize: null,
      );
}
