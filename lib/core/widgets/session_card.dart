import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/session.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_card.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/qr_scanner_page/qr_scanner_page.dart';

import 'custom_stepper.dart' as stepper;

class SessionCard extends StatelessWidget {
  const SessionCard({
    Key? key,
    required this.session,
    required this.getPlacemark,
    required this.onSessionCreated,
  }) : super(key: key);

  final Session session;
  final Future<Placemark?> getPlacemark;
  final void Function() onSessionCreated;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.zero,
      color: session.finishTime == null ? AppColors.success.withOpacity(0.15) : null,
      border: Border.all(width: 0.5, color: session.finishTime == null ? AppColors.success : AppColors.grey.withOpacity(0.75)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Application.isDarkMode(context) ? AppColors.grey : AppColors.lightGrey,
              borderRadius: AppConstraints.borderRadius,
            ),
            child: Text(
              '#${session.pk}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          stepper.CustomStepper(
            physics: const NeverScrollableScrollPhysics(),
            controlsBuilder: (context, details) => const EmptyBox(),
            steps: [
              stepper.Step(
                title: Text('session_start_time'.tr()),
                state: stepper.StepState.complete,
                isActive: false,
                content: OneLineCell(
                  title: Utils.getNamedDateTime(session.startTime),
                  needIcon: false,
                  needBorder: true,
                  centerTitle: true,
                  onTap: () {},
                ),
              ),
              stepper.Step(
                title: Text('session_end_time'.tr()),
                state: session.finishTime != null ? stepper.StepState.complete : stepper.StepState.editing,
                isActive: false,
                content: OneLineCell(
                  title: session.finishTime == null ? 'end_session'.tr() : Utils.getNamedDateTime(session.finishTime),
                  needIcon: false,
                  needBorder: true,
                  centerTitle: true,
                  onTap: () {
                    if (session.isActive()) {
                      Navigator.of(context).push(
                        CustomPageRoute(
                          child: Scaffold(
                            appBar: AppBar(leading: AppCloseButton(), automaticallyImplyLeading: false),
                            body: QRScannerPage(
                              changeTab: (i) {},
                              onSessionCreated: onSessionCreated,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const EmptyBox(height: 24.0),
          FutureBuilder(
            future: getPlacemark,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return const CircularProgressIndicator.adaptive();
              }
              if (snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_pin),
                    Flexible(
                      child: Text(
                        snapshot.data!.toString(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              }
              return const EmptyBox();
            },
          ),
        ],
      ),
    );
  }
}
