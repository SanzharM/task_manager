import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/user_card.dart';
import 'package:easy_localization/easy_localization.dart';

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({Key? key, required this.users}) : super(key: key);
  final List<User> users;

  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  String _phone = '';
  List<User> collegues = [];

  void initialize() async {
    _phone = await Application.getPhone() ?? '';
    widget.users.forEach((e) {
      if (e.phone != _phone) collegues.add(e);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
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
        child: Builder(
          builder: (context) {
            if (collegues.isEmpty)
              return FutureBuilder(
                future: Application.getCompanyCode(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CupertinoActivityIndicator();
                  }
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: snapshot.data.toString()));
                        AlertController.showResultDialog(context: context, message: 'company_code_copied'.tr());
                      },
                      child: Center(
                        child: Text(
                          'У вас пока нет коллег.\nВы можете их пригласить по ссылке #${snapshot.data}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'У вас пока нет коллег',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              );
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const BouncingScrollPhysics(),
              itemCount: collegues.length,
              itemBuilder: (context, index) {
                if (collegues[index].phone == _phone) {
                  return const EmptyBox();
                }
                return UserCard(user: collegues[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
