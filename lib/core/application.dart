import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/app_theme.dart';

class Application {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const _taskManagerToken = 'TaskManagerToken';
  static const _notificationsToken = 'TaskManagerNotificationsToken';
  static const _themeToken = 'TaskManagerThemeToken';
  static const _localeKey = 'TaskManagerLocaleToken';

  static String getBaseUrl() => 'http://10.10.80.238:8000';

  static Future<bool> isAuthorized() async {
    return (await _prefs).getString(_taskManagerToken) != null;
  }

  static Future<void> setToken(String? token) async {
    if (token == null) {
      (await _prefs).remove(_taskManagerToken);
      return;
    }
    (await _prefs).setString(_taskManagerToken, token);
  }

  static Future<String?> getToken() async {
    return (await _prefs).getString(_taskManagerToken);
  }

  static bool isDarkMode(BuildContext context) {
    try {
      return Provider.of<ThemeNotifier>(context).getThemeMode() == ThemeMode.dark;
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    (await _prefs).setString(_themeToken, '$mode'.split('.').last);
  }

  static Future<ThemeMode?> getSavedThemeMode() async {
    final theme = (await _prefs).getString(_themeToken);
    switch (theme?.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  static void setThemeMode(BuildContext context, ThemeMode mode) {
    Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(mode);
  }

  static Future<bool> getNotifications() async {
    return (await _prefs).getBool(_notificationsToken) ?? true;
  }

  static Future<void> setNotifications(bool value) async {
    await (await _prefs).setBool(_notificationsToken, value);
  }

  static Future<Locale?> getLocale() async {
    return AppLocales.getLocaleFromString((await _prefs).getString(_localeKey));
  }

  static Future<void> setLocale(Locale locale) async {
    (await _prefs).setString(_localeKey, locale.languageCode);
  }
}
