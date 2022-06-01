import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/session.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/custom_shimmer.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/qr_scanner_page/bloc/qr_bloc.dart';

class PersonalAccount extends StatefulWidget {
  final User user;
  const PersonalAccount({Key? key, required this.user}) : super(key: key);

  @override
  _PersonalAccountState createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  final _sessionsBloc = QrBloc();

  List<Session> _sessions = [];
  bool areSessionsLoading = false;

  @override
  void initState() {
    super.initState();
    _sessionsBloc.getSessions();
  }

  @override
  void dispose() {
    _sessionsBloc.close();
    super.dispose();
  }

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataInfoCell(
              title: 'total_money'.tr(),
              value: widget.user.totalMoney?.toString() ?? '-',
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8.0),
            ),
            const EmptyBox(height: 12.0),
            DataInfoCell(
              title: 'total_money_per_hour'.tr(),
              value: widget.user.moneyPerHour?.toString() ?? '-',
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8.0),
            ),
            const EmptyBox(height: 12.0),
            DataInfoCell(
              title: 'birthday'.tr(),
              value: Utils.toDateString(widget.user.birthday, includeMonthTitles: true),
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(8.0),
              onPressed: widget.user.birthday == null
                  ? null
                  : () => AlertController.showSimpleDialog(
                        context: context,
                        message: 'your_birthday_after'.tr(args: [Utils.getNextBirthdayDaysLeft(widget.user.birthday!)]),
                      ),
            ),
            const EmptyBox(height: 20.0),
            BlocConsumer(
              bloc: _sessionsBloc,
              listener: (context, state) {
                areSessionsLoading = state is QrLoading;
                if (state is QrSessionsLoaded) {
                  _sessions = state.sessions.reversed.toList();
                }
                setState(() {});
              },
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => SizeTransition(sizeFactor: animation, child: child),
                  child: (_sessions.isEmpty && state is! QrLoading)
                      ? Center(
                          child: Text('list_is_empty'.tr(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                        )
                      : CustomShimmer(
                          enabled: state is QrLoading,
                          child: Column(
                            children: [
                              Text(
                                'attendence'.tr(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const EmptyBox(height: 12.0),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: double.maxFinite,
                                child: CupertinoScrollbar(
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _sessions.toList().length,
                                    separatorBuilder: (_, i) => const EmptyBox(width: 8.0),
                                    itemBuilder: (context, i) {
                                      final startDate = Utils.toDateString(_sessions[i].startTime);
                                      final endDate = Utils.toDateString(_sessions[i].finishTime);
                                      return Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: Application.isDarkMode(context) ? AppColors.grey : AppColors.defaultGrey,
                                          borderRadius: AppConstraints.borderRadius,
                                        ),
                                        child: Text(startDate + ' - ' + endDate),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
            InfoCell(
              title: 'current_shift'.tr(),
              value: '09:00 - 18:00',
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
