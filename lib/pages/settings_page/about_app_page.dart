import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/app_info.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  final AppInfo appInfo = AppInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'app_name'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36, color: AppColors.lightAction, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: const Text(
                    'Task Management application',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 56)),
                FutureBuilder<String>(
                  future: AppInfo.getAppVersion(),
                  builder: (context, snapshot) => Text(
                    'app_version'.tr() + '\n${snapshot.data ?? '-'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
