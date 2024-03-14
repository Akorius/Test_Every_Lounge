abstract class UpdateStorage {
  /// Используется для определения - в какой версии нужно показывать модалку
  /// и в какой он уже ее видел

  void addAppVersion(String currentVersion);

  bool needShowUpdate(String currentVersion);
}
