import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';
import 'package:task_manager/pages/login_page/login_page.dart';
import 'package:task_manager/pages/navigation_bar.dart';

class AppRouter {
  static void toMainPage(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => NavigationBar()));
  }

  static void toIntroPage(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(CustomPageRoute(child: IntroPage(), direction: AxisDirection.left));
  }

  static void toLoginPage(BuildContext context, String companyCode) {
    Navigator.of(context).push(CustomPageRoute(child: LoginPage(companyCode: companyCode)));
  }
}
