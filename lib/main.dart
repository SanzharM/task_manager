import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/app_manager.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';

import 'core/app_theme.dart';
import 'pages/pin_page/pin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  StatefulWidget homeScreen = IntroPage();
  if (await Application.isAuthorized()) homeScreen = PinPage(shouldSetupPin: false);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ThemeMode _themeMode = await Application.getSavedThemeMode() ?? ThemeMode.light;
  final _startLocale = await Application.getLocale() ?? AppLocales.russian;

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      startLocale: _startLocale,
      supportedLocales: const [AppLocales.russian, AppLocales.english],
      fallbackLocale: AppLocales.russian,
      child: ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) => ThemeNotifier(_themeMode),
        child: App(homeScreen),
      ),
    ),
  );
}

class App extends StatelessWidget {
  final Widget homeScreen;
  App(this.homeScreen);

  @override
  Widget build(BuildContext context) {
    return AppManager(
      child: MaterialApp(
        title: 'Bota',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: Provider.of<ThemeNotifier>(context).getThemeMode(),
        home: homeScreen,
      ),
    );
  }
}
