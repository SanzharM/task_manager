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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('security'.tr()),
              const EmptyBox(height: 8.0),
              FutureBuilder<bool>(
                future: Application.useBiometrics(),
                builder: (context, snapshot) => SwitchCell(
                  title: 'Touch ID / Face ID',
                  value: snapshot.data ?? false,
                  onChanged: (value) async {
                    await Application.setUseBiometrics(value);
                    setState(() {});
                  },
                ),
              ),
              const EmptyBox(height: 8.0),
              FutureBuilder<bool>(
                future: Application.useVoiceAuth(),
                builder: (context, snapshot) => SwitchCell(
                  title: 'voice_authentication'.tr(),
                  value: snapshot.data ?? false,
                  onChanged: (value) async {
                    await Application.setUseVoiceAuth(value);
                    setState(() {});
                  },
                ),
              ),
              const EmptyBox(height: 8.0),
              FutureBuilder<bool>(
                future: Application.usePinCode(),
                builder: (context, snapshot) => SwitchCell(
                  title: 'pin_code'.tr(),
                  value: snapshot.data ?? false,
                  onChanged: (value) async {
                    await Application.setUsePinCode(value);
                    setState(() {});
                  },
                ),
              ),
              const EmptyBox(height: 20.0),
              Text('theme_mode'.tr()),
              const EmptyBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ChangeModeButton(
                      icon: CupertinoIcons.sun_max_fill,
                      mode: ThemeMode.light,
                      onTap: () => setState(() {}),
                    ),
                  ),
                  Expanded(
                    child: ChangeModeButton(
                      icon: Icons.nightlight_round_outlined,
                      mode: ThemeMode.dark,
                      onTap: () => setState(() {}),
                    ),
                  ),
                ],
              ),
              const EmptyBox(height: 20.0),
              Text('other_settings'.tr()),
              const EmptyBox(height: 8.0),
              SwitchCell(
                title: 'notifications'.tr(),
                value: _notifications,
                onChanged: onNotification,
              ),
              const EmptyBox(height: 20.0),
              Text('language'.tr()),
              const EmptyBox(height: 8.0),
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), color: Application.isDarkMode(context) ? AppColors.snow : AppColors.darkGrey),
        child: Icon(
          icon,
          size: 32,
          color: Application.isDarkMode(context) ? AppColors.darkGrey : AppColors.snow,
        ),
      ),
    );
  }
}
