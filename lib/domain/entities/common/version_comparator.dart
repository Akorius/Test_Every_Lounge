enum VersionComparisonResult {
  less,
  greater,
  equal, // Версии равны
}

class VersionComparator {
  static bool isUpdateAvailable(String currentVersion, String settingVersion) {
    // Разбиваем версии на компоненты
    List<int> versionA = currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> versionB = settingVersion.split('.').map((e) => int.parse(e)).toList();
    // Сравниваем каждый компонент
    return _compareVersions(versionA, versionB) == VersionComparisonResult.less;
  }

  static VersionComparisonResult _compareVersions(List<int> versionA, List<int> versionB) {
    for (int i = 0; i < versionA.length; i++) {
      if (versionA[i] < versionB[i]) {
        return VersionComparisonResult.less;
      } else if (versionA[i] > versionB[i]) {
        return VersionComparisonResult.greater;
      }
    }
    return VersionComparisonResult.equal;
  }
}
