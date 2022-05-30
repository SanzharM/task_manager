import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/app_theme.dart';
import 'package:task_manager/core/supporting/app_router.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';
import 'package:task_manager/pages/task_board/ui/task_board_builder.dart';

class Application {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static const _taskManagerToken = 'TaskManagerToken';
  static const _notificationsToken = 'TaskManagerNotificationsToken';
  static const _themeToken = 'TaskManagerThemeToken';
  static const _localeKey = 'TaskManagerLocaleToken';
  static const _pinKey = 'TaskManagerPinToken';
  static const _phoneKey = 'TaskManagerPhoneToken';
  static const _companyCodeKey = 'TaskManagerCompanyCodeToken';
  static const _boardSortOrder = 'TaskManagerBoardSortOrderToken';
  static const _wrongAttemptsKey = 'TaskManagerWrongVoiceAttempts';

  // Settings preferences
  static const _biometricsKey = 'TaskManagerBiometricsKey';
  static const _voiceAuthKey = 'TaskManagerVoiceAuthKey';
  static const _pinCodeKey = 'TaskManagerPinCodeKey';

  // static String getBaseUrl() => 'http://192.168.1.103:8000';
  static String getBaseUrl() => 'https://app-bota.org';

  static Future<bool> isAuthorized() async {
    return (await getToken()) != null;
  }

  static Future<void> setToken(String? token) async {
    if (token == null) return _storage.delete(key: _taskManagerToken);

    return await _storage.write(key: _taskManagerToken, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _taskManagerToken);
  }

  static Future<String?> getPhone() async {
    return await _storage.read(key: _phoneKey);
  }

  static Future<void> setPhone(String? phone) async {
    if (phone == null || phone.isEmpty) {
      await _storage.delete(key: _phoneKey);
    } else {
      await _storage.write(key: _phoneKey, value: phone);
    }
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

  static Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  static Future<void> setPin(String? pin) async {
    if (pin == null) return await _storage.delete(key: _pinKey);
    return await _storage.write(key: _pinKey, value: pin);
  }

  static Future<void> saveCompanyCode(String code) async {
    return await _storage.write(key: _companyCodeKey, value: code);
  }

  static Future<String?> getCompanyCode() async {
    return await _storage.read(key: _companyCodeKey);
  }

  static Future<void> setBoardSortOrder(SortOrder order) async {
    (await _prefs).setString(_boardSortOrder, order.toString().split('.').last);
    return;
  }

  static Future<SortOrder> getBoardSortOrder() async {
    final value = (await _prefs).getString(_boardSortOrder);
    if (value == 'status') return SortOrder.status;
    return SortOrder.time;
  }

  static Future<void> clearStorage({BuildContext? context}) async {
    _storage.deleteAll();
    if (context != null) return AppRouter.toIntroPage(context);
  }

  static void logout(BuildContext context) async {
    await Application.setToken(null);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(CustomPageRoute(direction: AxisDirection.right, child: IntroPage()));
  }

  static Future<void> setWrongVoiceAttempts(int i) async {
    return _storage.write(key: _wrongAttemptsKey, value: i.toString());
  }

  static Future<int> getWrongVoiceAttempts() async {
    return int.tryParse(await _storage.read(key: _wrongAttemptsKey) ?? '') ?? 0;
  }

  // Biometrics
  static Future<void> setUseBiometrics(bool? value) async {
    if (value == null) {
      return _storage.delete(key: _biometricsKey);
    } else {
      return await _storage.write(key: _biometricsKey, value: '$value');
    }
  }

  static Future<bool> useBiometrics() async {
    return await _storage.read(key: _biometricsKey) == 'true';
  }

  // Voice Auth
  static Future<void> setUseVoiceAuth(bool? value) async {
    if (value == null) {
      return await _storage.delete(key: _voiceAuthKey);
    } else {
      return await _storage.write(key: _voiceAuthKey, value: '$value');
    }
  }

  static Future<bool> useVoiceAuth() async {
    return await _storage.read(key: _voiceAuthKey) == 'true';
  }

  // Pin Code
  static Future<void> setUsePinCode(bool? value) async {
    if (value == null) {
      return await _storage.delete(key: _pinCodeKey);
    } else {
      return await _storage.write(key: _pinCodeKey, value: '$value');
    }
  }

  static Future<bool> usePinCode() async {
    return await _storage.read(key: _pinCodeKey) == 'true';
  }
}
