import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/app_colors.dart';

class AppTheme {
  get darkTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.darkGrey,
        bottomAppBarColor: AppColors.darkGrey,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: AppColors.darkGrey,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
          titleTextStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: AppColors.metal),
        ),
        fontFamily: 'Montserrat',
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.grey),
          labelStyle: TextStyle(color: AppColors.metal),
          errorStyle: TextStyle(color: AppColors.darkRed),
        ),
        textTheme: TextTheme().apply(
          bodyColor: AppColors.metal,
          displayColor: AppColors.metal,
        ),
        tabBarTheme: TabBarTheme(labelStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500)),
        iconTheme: IconThemeData(color: AppColors.snow, size: 24),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          primaryColor: AppColors.snow,
          scaffoldBackgroundColor: AppColors.darkGrey,
          brightness: Brightness.dark,
          textTheme: const CupertinoTextThemeData(
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
        dividerColor: Colors.transparent,
      );

  get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.snow,
        // snackBarTheme: SnackBarThemeData(),
        bottomAppBarColor: AppColors.snow,
        backgroundColor: AppColors.snow,
        splashFactory: NoSplash.splashFactory,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          color: AppColors.snow,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkGrey),
          titleTextStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 20, color: AppColors.darkGrey),
        ),
        fontFamily: 'Montserrat',
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.darkGrey),
          labelStyle: TextStyle(color: AppColors.darkGrey),
          errorStyle: TextStyle(color: AppColors.lightRed),
        ),
        textTheme: const TextTheme().apply(
          bodyColor: AppColors.darkGrey,
          displayColor: AppColors.darkGrey,
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
        ),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          primaryColor: AppColors.darkGrey,
          scaffoldBackgroundColor: AppColors.snow,
          brightness: Brightness.light,
          textTheme: const CupertinoTextThemeData(
            primaryColor: AppColors.darkGrey,
            textStyle: TextStyle(
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
        dividerColor: Colors.transparent,
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
