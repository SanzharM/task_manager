import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';

class AppTheme {
  get darkTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.darkGrey,
        bottomAppBarColor: AppColors.darkGrey,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: AppColors.darkGrey,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
        fontFamily: 'Cuprum',
        accentColorBrightness: Brightness.dark,
        primaryColorBrightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.grey),
          labelStyle: TextStyle(color: AppColors.metal),
        ),
        textTheme: TextTheme().apply(
          bodyColor: AppColors.metal,
          displayColor: AppColors.metal,
        ),
        iconTheme: IconThemeData(color: AppColors.snow, size: 24),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          primaryColor: AppColors.snow,
          scaffoldBackgroundColor: AppColors.darkGrey,
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(primaryColor: AppColors.darkGrey),
        ),
        primaryColor: AppColors.darkGrey,
        brightness: Brightness.dark,
        canvasColor: AppColors.grey,
        accentColor: AppColors.darkGrey,
        accentIconTheme: IconThemeData(color: Colors.white),
      );

  get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.snow,
        bottomAppBarColor: AppColors.snow,
        backgroundColor: AppColors.snow,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: AppColors.snow,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkGrey),
        ),
        accentColorBrightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        fontFamily: 'Cuprum',
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.darkGrey),
          labelStyle: TextStyle(color: AppColors.darkGrey),
        ),
        textTheme: TextTheme().apply(
          bodyColor: AppColors.darkGrey,
          displayColor: AppColors.darkGrey,
        ),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          primaryColor: AppColors.darkGrey,
          scaffoldBackgroundColor: AppColors.snow,
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(primaryColor: AppColors.darkGrey),
        ),
        iconTheme: IconThemeData(color: AppColors.darkGrey, size: 24),
        primaryColor: AppColors.darkGrey,
        brightness: Brightness.light,
        canvasColor: AppColors.grey,
        accentColor: AppColors.snow,
        accentIconTheme: IconThemeData(color: AppColors.darkGrey),
      );
}

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  getThemeMode() => _themeMode;

  setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
