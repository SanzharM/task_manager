import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/voice_authentication/voice_authentication_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.changeLanguage}) : super(key: key);

  final void Function(Locale) changeLanguage;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = false;
  bool? hasVoice;

  void _getSettings() async {
    _notifications = await Application.getNotifications();
    hasVoice = (await ApiClient.checkRecordedVoice(null)).success == true;
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
              const EmptyBox(height: 12.0),
              OneLineCell(
                title: 'voice_authentication'.tr(),
                onTap: _voiceAuthOptions,
                icon: hasVoice == null ? const CupertinoActivityIndicator() : const Icon(CupertinoIcons.mic_fill),
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

  void _voiceAuthOptions() async {
    if (hasVoice == null) return;
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('voice_authentication'.tr(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            const EmptyBox(height: 12.0),
            OneLineCell(
              title: hasVoice! ? 'renew_voice' : 'register_voice'.tr(),
              icon: const Icon(CupertinoIcons.mic_fill),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: VoiceAuthenticationPage(
                      mode: AuthMode.register,
                      onNext: () {
                        setState(() {});
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
            const EmptyBox(height: 12.0),
            if (hasVoice!)
              OneLineCell(
                title: 'delete'.tr(),
                icon: const Icon(CupertinoIcons.delete, color: AppColors.lightRed),
                onTap: () async {
                  final isDeleted = await ApiClient.deleteVoice();
                  Navigator.of(context).pop();
                  if (isDeleted.success == true) {
                    AlertController.showResultDialog(
                      context: context,
                      message: 'voice_deleted'.tr(),
                      isSuccess: false,
                    );
                  } else {
                    AlertController.showResultDialog(
                      context: context,
                      message: 'unable_to_deleted_voice'.tr(),
                      isSuccess: null,
                    );
                  }
                },
              ),
            const EmptyBox(height: 24.0),
            OneLineCell(
              title: 'done'.tr(),
              centerTitle: true,
              needIcon: false,
              onTap: () => Navigator.of(context).pop(),
            ),
            const EmptyBox(height: 16.0),
          ],
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
