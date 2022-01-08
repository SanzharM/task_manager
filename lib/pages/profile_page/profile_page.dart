import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/profile_page/add_profile_page.dart';
import 'package:task_manager/pages/profile_page/team_members_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  void _toEditProfile() => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => AddProfilePage(user: _user, isEditing: true),
        ),
      );

  void _toTeamMembers() => Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => TeamMembersPage(user: _user!)));

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Профиль',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Profile Cells
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: const Icon(CupertinoIcons.person),
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
                        onTap: () => print('to settings'),
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
