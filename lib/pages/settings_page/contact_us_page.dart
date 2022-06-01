import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('contact_us'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        children: [
          OneLineCell(
            title: 'E-mail',
            leading: const Icon(CupertinoIcons.mail_solid),
            icon: const Icon(CupertinoIcons.forward),
            onTap: () async => await launch('mailto:samorazvitie1811@gmail.com'),
          ),
          const EmptyBox(height: 12.0),
          OneLineCell(
            title: 'phone_number'.tr(),
            leading: const Icon(CupertinoIcons.phone_fill),
            icon: const Icon(CupertinoIcons.forward),
            onTap: () async => await launch('tel:77001112233'),
          ),
        ],
      ),
    );
  }
}
