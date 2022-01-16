import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/models/organization.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';

class OrganizationPage extends StatefulWidget {
  final Organization? organization;
  const OrganizationPage(this.organization);

  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  late Organization _organization;

  @override
  void initState() {
    _organization = widget.organization ?? Organization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: AppBackButton(),
        title: Text(_organization.name ?? 'Организация'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppCard(
                child: Column(
                  children: [
                    ArrowedCell(
                      icon: const Icon(CupertinoIcons.qrcode),
                      title: 'Сгенерировать QR-код',
                      onTap: () => null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
