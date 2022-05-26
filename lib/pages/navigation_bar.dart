import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/pages/profile_page/profile_page.dart';
import 'package:task_manager/pages/qr_scanner_page/qr_scanner_page.dart';
import 'package:task_manager/pages/task_board/task_board_page.dart';
import 'package:easy_localization/easy_localization.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final GlobalKey<TaskBoardState> _taskBoardKey = GlobalKey();
  final GlobalKey<QRScannerPageState> _qrKey = GlobalKey();
  final GlobalKey<ProfilePageState> _profileKey = GlobalKey();

  List<Widget> pages = [];

  int _currentIndex = 0;

  _updateState() {
    setState(() {});
  }

  void _updateLanguage(Locale locale) async {
    if (!context.supportedLocales.contains(locale)) return print('\nUnsupport locale. Returning.');
    await context.setLocale(locale);
    await Application.setLocale(locale);
  }

  void _changeTab(int index) {
    if (index < 0 || index > pages.length) return;
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    pages = [
      TaskBoard(key: _taskBoardKey, changeTab: _changeTab),
      QRScannerPage(key: _qrKey, changeTab: _changeTab),
      ProfilePage(key: _profileKey, changeLanguage: _updateLanguage, changeTab: _changeTab),
    ];
    _currentIndex = pages.length - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: null,
        activeColor: Application.isDarkMode(context) ? AppColors.snow : AppColors.darkGrey,
        inactiveColor: Application.isDarkMode(context) ? AppColors.snow : AppColors.darkGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex == index) {
            if (_currentIndex == 0) _taskBoardKey.currentState?.animateTabTo(0);
            if (_currentIndex == 2) _profileKey.currentState?.scrollToTop();
          } else {
            _currentIndex = index;
            _updateState();
          }
          // Resume or Pause camera if it is or is not QR page
          if (_currentIndex == 1)
            _qrKey.currentState?.resumeCamera();
          else
            _qrKey.currentState?.stopCamera();

          HapticFeedback.lightImpact();
        },
        backgroundColor: AppColors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.table_badge_more),
            activeIcon: Icon(CupertinoIcons.table_badge_more_fill),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode_viewfinder),
            activeIcon: Icon(CupertinoIcons.qrcode_viewfinder),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
          ),
        ],
      ),
    );
  }
}
