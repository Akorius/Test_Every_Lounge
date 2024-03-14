class Qr {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String storageID;
  final String name;

  Qr({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.storageID,
    required this.name,
  });

  factory Qr.fromJson(Map<String, dynamic> json) => Qr(
        id: json['id'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        storageID: json['StorageID'] as String,
        name: json['Name'] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'StorageID': storageID,
      'Name': name,
    };
  }
}
