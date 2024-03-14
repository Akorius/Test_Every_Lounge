import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/data/api/settings.dart';
import 'package:everylounge/domain/data/storages/settings.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/settings/settings.dart';

abstract class SettingsUseCase {
  Future<Result<AppSettings>> getSettings({bool? isInit});
}

class SettingsUseCaseImpl implements SettingsUseCase {
  final AppSettingsApi _settingsApi = getIt();
  final SettingsStorage _settingsStorage = getIt();

  @override
  Future<Result<AppSettings>> getSettings({bool? isInit = false}) async {
    try {
      if (_settingsStorage.settings == null || isInit == true) {
        final AppSettings result = await _settingsApi.getSettings();
        _settingsStorage.settings = result;
      }
      return Result.success(_settingsStorage.settings!);
    } catch (e, s) {
      Log.exception(e, s, "SettingsUseCaseImpl");
      _settingsStorage.clear();

      return Result.failure("Не удалось получить настройки.");
    }
  }
}
