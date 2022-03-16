import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.changeLanguage}) : super(key: key);

  final void Function(Locale) changeLanguage;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = false;

  void _getSettings() async {
    _notifications = await Application.getNotifications();
    setState(() {});
  }

  void onNotification(bool value) async {
    await Application.setNotifications(value);
    setState(() => _notifications = value);
  }

  @override
  void initState() {
    super.initState();
    _getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('settings'.tr()),
        leading: AppBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SwitchCell(
                  title: 'notifications'.tr(),
                  value: _notifications,
                  onChanged: onNotification,
                ),
              ),
              EmptyBox(height: 12),
              Column(
                children: [
                  Text('theme_mode'.tr()),
                  EmptyBox(height: 4),
                  Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(maxHeight: 72),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChangeModeButton(
                          icon: CupertinoIcons.sun_max_fill,
                          mode: ThemeMode.light,
                          onTap: () => setState(() {}),
                        ),
                        ChangeModeButton(
                          icon: Icons.nightlight_round_outlined,
                          mode: ThemeMode.dark,
                          onTap: () => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < context.supportedLocales.length; i++)
                CountryCell(
                  isSelected: context.locale == context.supportedLocales[i],
                  locale: context.supportedLocales[i],
                  onTap: () => widget.changeLanguage(context.supportedLocales[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeModeButton extends StatelessWidget {
  final IconData icon;
  final ThemeMode mode;
  final void Function() onTap;

  const ChangeModeButton({
    required this.icon,
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        if (mode == await Application.getSavedThemeMode()) return;

        await Application.saveThemeMode(mode);
        Application.setThemeMode(context, mode);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: MediaQuery.of(context).size.width / 3,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: Application.isDarkMode(context) ? AppColors.snow : AppColors.darkGrey),
        child: Icon(
          icon,
          size: 32,
          color: Application.isDarkMode(context) ? AppColors.darkGrey : AppColors.snow,
        ),
      ),
    );
  }
}
