import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/app_theme.dart';

class Application {
  static const _taskManagerToken = 'TaskManagerToken';
  static const _notificationsToken = 'TaskManagerNotificationsToken';
  static const _themeToken = 'TaskManagerThemeToken';

  static Future<bool> isAuthorized() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_taskManagerToken) == null;
  }

  static Future<void> setToken(String? token) async {
    final _prefs = await SharedPreferences.getInstance();
    if (token == null) {
      _prefs.remove(_taskManagerToken);
      return;
    }
    _prefs.setString(_taskManagerToken, token);
  }

  static Future<String?> getToken() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString(_taskManagerToken);
  }

  static bool isDarkMode(BuildContext context) {
    try {
      return Provider.of<ThemeNotifier>(context).getThemeMode() ==
          ThemeMode.dark;
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_themeToken, '$mode'.split('.').last);
  }

  static Future<ThemeMode?> getSavedThemeMode() async {
    final _prefs = await SharedPreferences.getInstance();
    final theme = _prefs.getString(_themeToken);
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
    Provider.of<ThemeNotifier>(context).setThemeMode(mode);
  }

  static Future<bool> getNotifications() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_notificationsToken) ?? true;
  }

  static Future<void> setNotifications(bool value) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(_notificationsToken, value);
  }
}
