import 'package:equatable/equatable.dart';

class Passengers extends Equatable {
  String firstName;
  String lastName;

  Passengers({
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }

  @override
  List<Object?> get props => [firstName, lastName];
}
