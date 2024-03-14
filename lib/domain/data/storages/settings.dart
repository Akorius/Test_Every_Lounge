import 'package:everylounge/domain/entities/settings/settings.dart';

abstract class SettingsStorage {
  late final AppSettings? settings;

  void clear();
}
