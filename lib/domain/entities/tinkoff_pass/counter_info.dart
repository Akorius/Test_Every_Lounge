import 'package:everylounge/domain/entities/tinkoff_pass/period.dart';

class CounterInfo {
  ///количество проходов
  final int? count;

  ///Вне зависимости от программы/подписки клиента и вне зависимости от count,
  ///если "isInfinity": true, тогда отображаем "безлимит
  final bool? isInfinity;
  final Period? period;

  CounterInfo({
    this.count,
    this.isInfinity,
    this.period,
  });

  factory CounterInfo.fromJson(Map<String, dynamic> json) {
    return CounterInfo(
      count: json['count'],
      isInfinity: json['isInfinity'],
      period: json['period'] != null ? Period.fromJson(json['period']) : null,
    );
  }

  CounterInfo copyWith({
    int? count,
    bool? isInfinity,
    Period? period,
  }) {
    return CounterInfo(
      count: count ?? this.count,
      isInfinity: isInfinity ?? this.isInfinity,
      period: period ?? this.period,
    );
  }
}
