import 'package:package_info_plus/package_info_plus.dart';

enum VersionComparison { Smaller, Latest, Greater }

class AppInfo {
  static const String appStoreId = '1558869067';
  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future<String> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static bool isLatestVersion({String? latestVersion, String? currentVersion}) {
    if (latestVersion == null || latestVersion.isEmpty || currentVersion == null || currentVersion.isEmpty) return true;

    final List<String> latestDigits = latestVersion.split('.');
    final List<String> currentDigits = currentVersion.split('.');
    final int availableLength = latestDigits.length > currentDigits.length ? latestDigits.length : currentDigits.length;

    for (int i = 0; i < availableLength; i++) {
      int latest = 0;
      int current = 0;
      try {
        latest = int.tryParse(latestDigits[i]) ?? 0;
      } catch (e) {}
      try {
        current = int.tryParse(currentDigits[i]) ?? 0;
      } catch (e) {}

      if (i + 1 < availableLength && (current > latest)) return true;
      if (latest > current) return false;
    }
    return true;
  }

  static VersionComparison getComparison({String? latestVersion, String? currentVersion}) {
    if (latestVersion == null || latestVersion.isEmpty || currentVersion == null || currentVersion.isEmpty) return VersionComparison.Latest;
    final List<String> latestDigits = latestVersion.split('.');
    final List<String> currentDigits = currentVersion.split('.');
    final int availableLength = latestDigits.length > currentDigits.length ? latestDigits.length : currentDigits.length;

    for (int i = 0; i < availableLength; i++) {
      int latest = 0;
      int current = 0;
      try {
        latest = int.tryParse(latestDigits[i]) ?? 0;
      } catch (e) {}
      try {
        current = int.tryParse(currentDigits[i]) ?? 0;
      } catch (e) {}

      if (i + 1 < availableLength && (current > latest)) return VersionComparison.Greater;
      if (latest > current) return VersionComparison.Smaller;
    }
    return VersionComparison.Latest;
  }
}
