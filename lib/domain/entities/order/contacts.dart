class Contacts {
  final String name;
  String phone;
  String email;

  Contacts({
    required this.name,
    this.phone = "",
    this.email = "",
  });

  factory Contacts.fromJson(Map<dynamic, dynamic> json) => Contacts(
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
