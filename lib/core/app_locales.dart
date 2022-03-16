import 'package:flutter/cupertino.dart';

class AppLocales {
  static const russian = Locale('ru');
  static const english = Locale('en');

  static bool isRus(Locale locale) => locale == russian;
  static bool isEng(Locale locale) => locale == english;

  static Locale? getLocaleFromString(String? locale) {
    switch (locale?.toLowerCase()) {
      case 'en':
        return english;
      case 'ru':
        return russian;
      default:
        return null;
    }
  }
}
