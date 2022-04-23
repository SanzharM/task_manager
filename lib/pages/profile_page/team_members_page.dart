import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/user_card.dart';
import 'package:easy_localization/easy_localization.dart';

class TeamMembersPage extends StatefulWidget {
  final User user;
  const TeamMembersPage({required this.user});
  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  bool isLoading = false;
  List<User> _teamMembers = [
    User(
      name: 'Collegue name',
      surname: 'Surname',
      email: 'abc@emaikl.com',
      phone: '77015557402',
      position: 'CLeaner',
    ),
    User(
      name: 'Abay',
      surname: 'Abaybekuly',
      email: 'asdasdaas@gmaikl.com',
      phone: '77015555246',
      position: 'System admininstrator',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('colleagues'.tr()),
        centerTitle: true,
        leading: AppBackButton(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const BouncingScrollPhysics(),
              itemCount: _teamMembers.length,
              itemBuilder: (context, index) {
                return UserCard(user: _teamMembers[index]);
              },
            ),
            if (isLoading && _teamMembers.isEmpty) CupertinoActivityIndicator(),
            if (!isLoading && _teamMembers.isEmpty)
              Center(
                child: Text(
                  'У вас пока нет коллег.\nВы можете их пригласить по ссылке #K4JF3A',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
