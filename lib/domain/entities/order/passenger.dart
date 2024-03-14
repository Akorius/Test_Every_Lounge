import 'package:everylounge/domain/entities/order/rate.dart';

class Passenger {
  final String firstName;
  final String lastName;
  final String middleName;
  final int age;
  final String? tariff;
  final int? amount;
  final String? code;
  final String? text;
  final int? segmentNumber;
  final DateTime? birthDate;
  final Rate? rate;
  late final bool isChild;

  Passenger({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.age,
    this.tariff,
    this.amount,
    this.code,
    this.text,
    this.segmentNumber,
    this.birthDate,
    this.rate,
  }) {
    isChild = age < 18 && birthDate != null;
  }

  factory Passenger.mock() => Passenger(
        firstName: 'Ivan',
        lastName: 'Smirnov',
        middleName: 'Petrovich',
        age: 32,
      );

  factory Passenger.fromJson(Map<dynamic, dynamic> json) => Passenger(
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        middleName: json['middle_name'] as String,
        age: json['age'] as int,
        tariff: json['tariff'] as String?,
        amount: json['amount'] as int?,
        code: json['code'] as String?,
        text: json['text'] as String?,
        segmentNumber: json['segment_number'] as int?,
        birthDate: json['birth_date'] != null ? DateTime.tryParse(json['birth_date']) ?? DateTime.now() : null,
        rate: json['rate'] != null ? Rate.fromJson(json['rate']) : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'age': age,
      'tariff': tariff,
      'amount': amount,
      'code': code,
      'text': text,
      'segment_number': segmentNumber,
      'birth_date': birthDate?.toString(),
      'rate': rate?.toJson()
    };
  }

  Passenger copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
    int? age,
    String? tariff,
    int? amount,
    String? code,
    String? text,
    int? segmentNumber,
    DateTime? birthDate,
    Rate? rate,
  }) {
    return Passenger(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      age: age ?? this.age,
      tariff: tariff ?? this.tariff,
      amount: amount ?? this.amount,
      code: code ?? this.code,
      text: text ?? this.text,
      segmentNumber: segmentNumber ?? this.segmentNumber,
      birthDate: birthDate ?? this.birthDate,
      rate: rate ?? this.rate,
    );
  }
}
