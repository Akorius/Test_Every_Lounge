class FileResponse {
  int id;
  String createdAt;
  String updatedAt;
  String storageID;
  String name;

  FileResponse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.storageID,
    required this.name,
  });

  FileResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        storageID = json['storage_id'],
        name = json['name'];

  @override
  String toString() {
    return 'FileResponse{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, storageID: $storageID, name: $name}';
  }
}
