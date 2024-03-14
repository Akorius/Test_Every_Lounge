import 'package:everylounge/domain/entities/file/file_response.dart';

abstract class FileApi {
  Future<FileResponse> upload(String filePath);
}
