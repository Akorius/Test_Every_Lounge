import 'dob.dart';

class Profile {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final int avatar;
  final String? phone;
  final int gender;
  final Dob? dob;

  Profile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.avatar,
    required this.phone,
    required this.gender,
    required this.dob,
  });

  Profile.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        userId = json['user_id'],
        firstName = json['first_name']?.trim(),
        middleName = json['middle_name']?.trim(),
        lastName = json['last_name']?.trim(),
        avatar = json['avatar'],
        phone = json['phone'],
        gender = json['gender'],
        dob = json['dob'] != null ? Dob.fromJson(json['dob']) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'avatar': avatar,
      'phone': phone,
      'gender': gender,
      'dob': dob?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Profile{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, firstName: $firstName, middleName: $middleName, lastName: $lastName, avatar: $avatar, phone: $phone, gender: $gender, dob: $dob}';
  }

  Profile copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    int? userId,
    String? firstName,
    String? middleName,
    String? lastName,
    int? avatar,
    String? phone,
    int? gender,
    Dob? dob,
  }) {
    return Profile(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
    );
  }
}
