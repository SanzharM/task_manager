import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/pages/login_page/login_page.dart';

import 'core/app_theme.dart';

void main() async {
  StatefulWidget homeScreen = LoginPage();
  // if (await Application.isAuthorized()) homeScreen = PinPage();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ThemeMode _themeMode = ThemeMode.light;
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (BuildContext context) => ThemeNotifier(_themeMode),
      child: App(homeScreen),
    ),
  );
}

class App extends StatelessWidget {
  final Widget homeScreen;
  App(this.homeScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskManager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: Provider.of<ThemeNotifier>(context).getThemeMode(),
      home: homeScreen,
    );
  }
}
