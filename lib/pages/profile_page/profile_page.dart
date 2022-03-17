import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/login_page/login_page.dart';
import 'package:task_manager/pages/organization_page/organization_page.dart';
import 'package:task_manager/pages/profile_page/add_profile_page.dart';
import 'package:task_manager/pages/profile_page/personal_account_page/personal_account_page.dart';
import 'package:task_manager/pages/profile_page/team_members_page.dart';
import 'package:task_manager/pages/settings_page/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.changeLanguage,
  }) : super(key: key);

  final void Function(Locale locale) changeLanguage;
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final _scrollController = ScrollController();
  User? _user;

  void _toEditProfile() => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => AddProfilePage(user: _user, isEditing: true),
        ),
      );

  void _toPersonalAccount() => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PersonalAccount(user: _user!)));

  void _toTeamMembers() => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TeamMembersPage(user: _user!)));

  void _toSettings() => Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => SettingsPage(changeLanguage: widget.changeLanguage),
      ));

  void _toOrganization() {
    if (_user?.organization == null) return;
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => OrganizationPage(_user!.organization!)));
  }

  void scrollToTop() => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );

  @override
  void initState() {
    _user = User(
      name: 'Sanzhar',
      surname: 'Predzashitnikov',
      email: 'abc@gmail.com',
      phone: '77015557402',
      position: 'Senior-super-puper-molodec',
      organization: Organization(name: 'Yandex LLC'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                // Profile Cells
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: _user?.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: _user!.imageUrl!,
                                fit: BoxFit.cover,
                                height: 48,
                                width: 48,
                                errorWidget: (context, url, error) => const Text('Не удалось загрузить фото'),
                              )
                            : const Icon(CupertinoIcons.person, size: 48),
                      ),
                      const EmptyBox(height: 12),
                      Text(
                        '${_user?.name ?? ''} ${_user?.surname ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const EmptyBox(height: 4),
                      Text(
                        _user?.phone ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                if (_user?.organization != null) const EmptyBox(height: 8),
                if (_user?.organization != null)
                  InfoCell(
                    title: 'Организация:',
                    value: _user?.organization?.name,
                    onTap: _toOrganization,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                const EmptyBox(height: 16),
                AppCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.person_fill),
                        title: 'edit_profile'.tr(),
                        onTap: _toEditProfile,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.chart_bar_alt_fill),
                        title: 'personal_account'.tr(),
                        onTap: _toPersonalAccount,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.person_3_fill),
                        title: 'your_colleagues'.tr(),
                        onTap: _toTeamMembers,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.calendar),
                        title: 'shift_history'.tr(),
                        onTap: () => print('to view schedule history'),
                      ),
                    ],
                  ),
                ),
                const EmptyBox(height: 12),
                AppCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.settings_solid),
                        title: 'settings'.tr(),
                        onTap: _toSettings,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.question_circle_fill),
                        title: 'contact_us'.tr(),
                        onTap: () => print('to contact us'),
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.info_circle_fill),
                        title: 'about_us'.tr(),
                        onTap: () => print('to about app'),
                      ),
                    ],
                  ),
                ),
                const EmptyBox(height: 8.0),
                AppButton(
                  title: 'logout'.tr(),
                  onTap: () async {
                    await Application.setToken(null);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                const EmptyBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
