import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/organization_page/organization_page.dart';
import 'package:task_manager/pages/profile_page/add_profile_page.dart';
import 'package:task_manager/pages/profile_page/team_members_page.dart';
import 'package:task_manager/pages/settings_page/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
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

  void _toTeamMembers() => Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => TeamMembersPage(user: _user!)));

  void _toSettings() => Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => SettingsPage()));

  void _toOrganization() {
    if (_user?.organization == null) return;
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => OrganizationPage(_user!.organization!)));
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
      surname: 'Bigdickbekov',
      email: 'abc@mail.ru',
      phone: '77015557402',
      position: 'Senior-super-puper-dohuya-molodec',
      organization: Organization(name: 'Google LLC'),
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
                                errorWidget: (context, url, error) =>
                                    const Text('Не удалось загрузить фото'),
                              )
                            : const Icon(CupertinoIcons.person, size: 48),
                      ),
                      EmptyBox(height: 12),
                      Text(
                        '${_user?.name ?? ''} ${_user?.surname ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      EmptyBox(height: 4),
                      Text(
                        _user?.phone ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                if (_user?.organization != null) EmptyBox(height: 8),
                if (_user?.organization != null)
                  InfoCell(
                    title: 'Организация:',
                    value: _user?.organization?.name,
                    onTap: _toOrganization,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                EmptyBox(height: 16),
                AppCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.person_fill),
                        title: 'Редактировать профиль',
                        onTap: _toEditProfile,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.chart_bar_alt_fill),
                        title: 'Личный кабинет',
                        onTap: () => print('to personal data'),
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.person_3_fill),
                        title: 'Ваши коллеги',
                        onTap: _toTeamMembers,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.calendar),
                        title: 'История ваших смен',
                        onTap: () => print('to view schedule history'),
                      ),
                    ],
                  ),
                ),
                EmptyBox(height: 12),
                AppCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.settings_solid),
                        title: 'Настройки',
                        onTap: _toSettings,
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.question_circle_fill),
                        title: 'Обратная связь',
                        onTap: () => print('to contact us'),
                      ),
                      ArrowedCell(
                        icon: const Icon(CupertinoIcons.info_circle_fill),
                        title: 'О приложении',
                        onTap: () => print('to about app'),
                      ),
                    ],
                  ),
                ),
                EmptyBox(height: 8.0),
                AppButton(
                  title: 'Выйти из аккаунта',
                  onTap: () => print('logout'),
                ),
                EmptyBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
