import 'card_type.dart';

class Bin {
  ///Первые 6 цифр банковской карты
  final String bin;

  ///Тип банка и его программа
  final BankCardType type;

  ///Количество проходов для себя по программе
  final int selfPasses;

  ///Количество проходов для гостей по программе
  final int guestPasses;

  Bin({
    required this.bin,
    required this.type,
    required this.selfPasses,
    required this.guestPasses,
  });

  factory Bin.fromJson(Map<dynamic, dynamic> json) {
    return Bin(
      bin: json['bin'] as String,
      type: bankCardTypeFromInt(json['type'] as int),
      selfPasses: json['self_passes'] as int,
      guestPasses: json['guest_passes'] as int,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'bin': bin,
      'type': type.index,
      'self_passes': selfPasses,
      'guest_passes': guestPasses,
    };
  }
}
