import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/app_theme.dart';

class Application {
  static const _taskManagerToken = 'TaskManagerToken';

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
}
