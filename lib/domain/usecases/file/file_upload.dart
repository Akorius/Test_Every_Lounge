import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/file.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/file/file_response.dart';

abstract class FileUploadUseCase {
  Future<Result<FileResponse>> call(String filePath);
}

class FileUploadUseCaseImpl implements FileUploadUseCase {
  final FileApi _fileApi = getIt();

  FileUploadUseCaseImpl();

  @override
  Future<Result<FileResponse>> call(String filePath) async {
    try {
      final result = await _fileApi.upload(filePath);
      return Result.success(result);
    } catch (e, s) {
      Log.exception(e, s, "FileUploadUseCaseImpl");
      return Result.failure("Не удалось обновить аватар");
    }
  }
}
