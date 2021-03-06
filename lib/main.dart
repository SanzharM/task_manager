import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/app_locales.dart';
import 'package:task_manager/core/app_manager.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/pages/authorization/authorization_controller.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';

import 'core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  StatefulWidget homeScreen = IntroPage();
  if (await Application.isAuthorized()) {
    // final bool hasVoice = (await ApiClient.checkRecordedVoice(null)).success == true;
    final List<AuthType> order = [];
    if (await Application.usePinCode()) {
      order.add(AuthType.pin);
    }
    // if (hasVoice) {
    //   order.add(AuthType.voice);
    // }
    print('\n\norder: $order');
    if (order.isNotEmpty)
      homeScreen = AuthController(
        authOrder: order,
        shouldSetupPin: await Application.getPin() == null,
      );
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  ));
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
