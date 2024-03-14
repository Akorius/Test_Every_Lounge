import 'package:everylounge/domain/entities/settings/settings.dart';

abstract class AppSettingsApi {
  Future<AppSettings> getSettings();
}
