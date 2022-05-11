import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({Key? key, required this.onPicked}) : super(key: key);

  final void Function(DateTime date) onPicked;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
              child: CupertinoDatePicker(
                onDateTimeChanged: (value) => onPicked(value),
                maximumYear: DateTime.now().year + 1,
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                minimumDate: DateTime.now(),
                minimumYear: DateTime.now().year,
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
              ),
            ),
            AppButton(
              title: 'done'.tr(),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
