import 'package:dio/dio.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/file.dart';
import 'package:everylounge/domain/entities/file/file_response.dart';

class FileApiImpl implements FileApi {
  final Dio _client = getIt();

  @override
  Future<FileResponse> upload(String filePath) async {
    FormData formData = FormData.fromMap({
      "attachment": await MultipartFile.fromFile(filePath, filename: 'image.jpg'),
    });
    final response = await _client.post(
      'files/upload',
      data: formData,
    );
    return FileResponse.fromJson(response.data["data"]);
  }
}
