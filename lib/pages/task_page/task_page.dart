import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/date_picker.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/core/widgets/value_picker.dart';
import 'package:task_manager/pages/task_page/bloc/task_bloc.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(this.task, {Key? key, this.onBack}) : super(key: key);

  final Task task;
  final void Function()? onBack;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _bloc = TaskBloc();
  late Task _task;

  bool isLoading = false;

  void _changeStatus() async {
    ValuePicker(
      context: context,
      title: 'status'.tr(),
      values: TaskStatus.values.map((e) => e.toString().split('.').last).toList(),
      onSelect: (value) {
        _task = _task.copyWith(status: Utils.getStatusFromString(value));
        setState(() {});
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    String deadline = Utils.dateToString(_task.deadline);
    if (deadline.isEmpty) deadline = '-';

    return GestureDetector(
      onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_task.title ?? 'task'.tr()),
          centerTitle: true,
          leading: AppBackButton(),
        ),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            isLoading = state is Loading;

            if (state is ErrorState) {
              AlertController.showSnackbar(context: context, message: state.error);
            }

            if (state is TaskEdited) {
              if (widget.onBack != null) widget.onBack!();
              Navigator.of(context).pop();
            }

            setState(() {});
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const EmptyBox(height: 16),
                  InfoCell.task(
                    title: 'id: ',
                    value: _task.pk?.toString(),
                  ),
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'creator'.tr() + ': ',
                    value: _task.creator?.name,
                  ),
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'performer'.tr() + ': ',
                    value: _task.performer?.name,
                  ),
                  const EmptyBox(height: 12),
                  InfoCell(
                    title: 'status'.tr() + ': ',
                    value: Utils.taskStatusToString(_task.status),
                    onTap: _changeStatus,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    padding: EdgeInsets.zero,
                  ),
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'created_date'.tr() + ': ',
                    value: Utils.dateToString(_task.createdAt),
                  ),
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'deadline'.tr() + ': ',
                    value: deadline,
                    onTap: () async {
                      await DatePicker(
                        minDate: _task.createdAt,
                        onPicked: (date) => setState(() => _task = _task.copyWith(deadline: date)),
                      ).show(context);
                      setState(() {});
                    },
                  ),
                  const EmptyBox(height: 12),
                  CupertinoScrollbar(
                    child: AppTextField(
                      label: 'description'.tr(),
                      text: _task.description,
                      maxLines: 3,
                      onTap: () => setState(() {}),
                      onChanged: (value) => _task = _task.copyWith(description: value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _task.didChanges(widget.task)
            ? AppButton(
                title: 'edit'.tr(),
                color: AppColors.lightAction,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                isLoading: isLoading,
                onTap: () {
                  if (!isLoading) _bloc.editTask(_task);
                },
              )
            : null,
      ),
    );
  }
}
