import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonalAccount extends StatefulWidget {
  final User user;
  const PersonalAccount({Key? key, required this.user}) : super(key: key);

  @override
  _PersonalAccountState createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('personal_account'.tr()),
        leading: AppBackButton(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'attendence'.tr(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              child: charts.BarChart(
                _createData(),
                animationDuration: const Duration(milliseconds: 400),
                animate: true,
              ),
            ),
            InfoCell(
              title: 'current_shift'.tr(),
              value: '10:00 - 19:00',
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ),
    );
  }

  static List<charts.Series<Bar, String>> _createData() {
    final data = [
      Bar(Utils.getMonth(DateTime.now().month - 2), 100),
      Bar(Utils.getMonth(DateTime.now().month - 1), 97),
      Bar(Utils.getMonth(DateTime.now().month), 85),
      Bar(Utils.getMonth(DateTime.now().month + 1), 100),
    ];

    return [
      charts.Series<Bar, String>(
        id: 'Attendence',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Bar bars, _) => bars.label,
        measureFn: (Bar bars, _) => bars.value,
        data: data,
      )
    ];
  }
}

class Bar {
  final String label;
  final double value;

  Bar(this.label, this.value);
}
