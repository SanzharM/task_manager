import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/pages/profile_page/profile_page.dart';
import 'package:task_manager/pages/qr_scanner_page/qr_scanner_page.dart';
import 'package:task_manager/pages/task_board/task_board.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final GlobalKey<TaskBoardState> _taskBoardKey = GlobalKey();
  final GlobalKey<ProfilePageState> _profileKey = GlobalKey();

  List<Widget> pages = [];

  int _currentIndex = 0;

  _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    pages = [
      TaskBoard(key: _taskBoardKey),
      QRScannerPage(),
      ProfilePage(key: _profileKey),
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
        activeColor: Application.isDarkMode(context)
            ? AppColors.snow
            : AppColors.darkGrey,
        inactiveColor: Application.isDarkMode(context)
            ? AppColors.snow
            : AppColors.darkGrey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex == index) {
            if (_currentIndex == 0) _taskBoardKey.currentState?.animateTabTo(0);
            if (_currentIndex == 2) _profileKey.currentState?.scrollToTop();
          } else {
            _currentIndex = index;
            _updateState();
          }
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
