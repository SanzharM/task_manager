import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/login_page/intro_page.dart';
import 'package:task_manager/pages/login_page/login_page.dart';
import 'package:task_manager/pages/navigation_bar.dart';
import 'package:task_manager/pages/organization_page/organization_page.dart';
import 'package:task_manager/pages/profile_page/add_profile_page.dart';
import 'package:task_manager/pages/profile_page/personal_account_page/personal_account_page.dart';
import 'package:task_manager/pages/profile_page/team_members_page.dart';
import 'package:task_manager/pages/settings_page/about_app_page.dart';
import 'package:task_manager/pages/settings_page/settings_page.dart';

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

  static void toEditProfile({required BuildContext context, User? user}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AddProfilePage(user: user, isEditing: true)));
  }

  static void toSettings({required BuildContext context, required void Function(Locale) changeLanguage}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SettingsPage(changeLanguage: changeLanguage)));
  }

  static void toAboutApp(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AboutAppPage()));
  }

  static void toTeamMembers({required BuildContext context, required List<User> users}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TeamMembersPage(users: users)));
  }

  static void toOrganizationPage({required BuildContext context, required Organization organization}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => OrganizationPage(organization)));
  }

  static toPersonalAccount({required BuildContext context, required User user}) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PersonalAccount(user: user)));
  }
}
