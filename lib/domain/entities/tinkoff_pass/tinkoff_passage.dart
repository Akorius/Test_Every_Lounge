import 'package:everylounge/domain/entities/tinkoff_pass/client_info.dart';
import 'package:everylounge/domain/entities/tinkoff_pass/counter_info.dart';

class TinkoffPassage {
  final ClientInfo? clientInfo;
  final CounterInfo? counterInfo;

  TinkoffPassage({
    required this.clientInfo,
    required this.counterInfo,
  });

  factory TinkoffPassage.fromJson(Map<String, dynamic> json) {
    return TinkoffPassage(
      clientInfo: ClientInfo.fromJson(json['clientInfo']),
      counterInfo: CounterInfo.fromJson(json['counterInfo']),
    );
  }

  TinkoffPassage copyWith({
    ClientInfo? clientInfo,
    CounterInfo? counterInfo,
  }) {
    return TinkoffPassage(
      clientInfo: clientInfo ?? this.clientInfo,
      counterInfo: counterInfo ?? this.counterInfo,
    );
  }

  TinkoffPassage.mock({bool? isInfinity, int? count})
      : this(clientInfo: null, counterInfo: CounterInfo(isInfinity: isInfinity ?? false, count: count ?? 0));
}
