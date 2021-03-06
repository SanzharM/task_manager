import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:easy_localization/easy_localization.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key? key,
    required this.onPicked,
    this.maxDate,
    this.minDate,
    this.initialDate,
    this.minYear,
    this.maxYear,
  }) : super(key: key);

  final void Function(DateTime date) onPicked;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? initialDate;
  final int? minYear;
  final int? maxYear;

  Future<void> show(BuildContext context) async => await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: AppConstraints.borderRadius),
        builder: (context) => DatePicker(
          onPicked: onPicked,
          minDate: minDate,
          maxDate: maxDate,
          minYear: minYear,
          maxYear: maxYear,
          initialDate: initialDate,
        ),
      );

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
                minimumYear: minYear ?? DateTime.now().year,
                maximumYear: maxYear ?? DateTime.now().year + 1,
                maximumDate: maxDate ?? DateTime.now().add(const Duration(days: 365)),
                minimumDate: minDate ?? DateTime.now(),
                initialDateTime: initialDate ?? DateTime.now(),
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
