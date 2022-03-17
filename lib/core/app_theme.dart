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
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        fontFamily: 'Montserrat',
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
          textTheme: CupertinoTextThemeData(
            primaryColor: AppColors.darkGrey,
            textStyle: const TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.metal,
            ),
          ),
        ),
        primaryColor: AppColors.darkGrey,
        brightness: Brightness.dark,
        canvasColor: AppColors.grey,
        accentColor: AppColors.darkGrey,
        accentIconTheme: IconThemeData(color: Colors.white),
      );

  get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.snow,
        // snackBarTheme: SnackBarThemeData(),
        bottomAppBarColor: AppColors.snow,
        backgroundColor: AppColors.snow,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          brightness: Brightness.light,
          color: AppColors.snow,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkGrey),
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
        ),
        accentColorBrightness: Brightness.light,
        primaryColorBrightness: Brightness.light,
        fontFamily: 'Montserrat',
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.darkGrey),
          labelStyle: TextStyle(color: AppColors.darkGrey),
        ),
        textTheme: TextTheme().apply(
          bodyColor: AppColors.darkGrey,
          displayColor: AppColors.darkGrey,
        ),
        tabBarTheme: TabBarTheme(labelStyle: const TextStyle(fontFamily: 'Montserrat')),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          primaryColor: AppColors.darkGrey,
          scaffoldBackgroundColor: AppColors.snow,
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
            primaryColor: AppColors.darkGrey,
            textStyle: const TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.darkGrey,
              fontSize: 16,
            ),
          ),
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
