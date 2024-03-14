import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class PremiumPassengers extends Equatable {
  String firstName;
  String lastName;
  bool child;
  DateTime? childBirthDate;

  PremiumPassengers({
    required this.firstName,
    required this.lastName,
    required this.child,
    this.childBirthDate,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    if (childBirthDate != null) {
      data['birth_date'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
        DateTime(
          childBirthDate!.year,
          childBirthDate!.month,
          childBirthDate!.day,
          childBirthDate!.hour,
          childBirthDate!.minute,
        ),
      );
    }
    return data;
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        child,
        childBirthDate,
      ];

  PremiumPassengers copyWith({
    String? firstName,
    String? lastName,
    bool? child,
    DateTime? childBirthDate,
  }) {
    return PremiumPassengers(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      child: child ?? this.child,
      childBirthDate: childBirthDate ?? this.childBirthDate,
    );
  }
}
