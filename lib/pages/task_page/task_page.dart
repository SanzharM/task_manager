import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';
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
  const TaskPage(this.task, {Key? key, this.users, this.onBack}) : super(key: key);

  final Task task;
  final List<User>? users;
  final void Function()? onBack;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _bloc = TaskBloc();
  late Task _task;

  List<User> _users = [];

  bool isLoading = false;

  void _changeStatus() async {
    ValuePicker(
      context: context,
      title: 'status'.tr(),
      values: TaskStatus.values.map((e) => e.toString().split('.').last).toList(),
      needTranslateValue: true,
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
    if (widget.users == null)
      _bloc.getUsers();
    else
      _users = widget.users!;
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
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.delete),
              onPressed: () {
                if (isLoading) return;
                AlertController.showNativeDialog(
                  context: context,
                  title: 'delete'.tr() + ' ?',
                  onYes: () {
                    _bloc.deleteTask(_task);
                    Navigator.of(context).pop();
                  },
                  onNo: () => Navigator.of(context).pop(),
                );
              },
            ),
          ],
        ),
        body: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            isLoading = state is Loading;

            if (state is ErrorState) {
              AlertController.showSnackbar(context: context, message: state.error);
            }

            if (state is TaskDeleted) {
              if (widget.onBack != null) widget.onBack!();
              Navigator.of(context).pop();
            }

            if (state is TaskEdited) {
              if (widget.onBack != null) widget.onBack!();
              Navigator.of(context).pop();
            }

            if (state is UsersLoaded) {
              _users = state.users;
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
                  AppTextField(
                    label: 'title'.tr(),
                    text: _task.title,
                    maxLines: 1,
                    needValidator: true,
                    onTap: () => setState(() {}),
                    onChanged: (value) => _task = _task.copyWith(title: value),
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
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'creator'.tr() + ': ',
                    value: _task.creator?.name ?? _task.creator?.phone,
                  ),
                  const EmptyBox(height: 12),
                  InfoCell.task(
                    title: 'performer'.tr() + ': ',
                    value: _task.performer?.name ?? _task.performer?.phone,
                    onTap: _choosePerformer,
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
                        initialDate: _task.deadline,
                        onPicked: (date) => setState(() => _task = _task.copyWith(deadline: date)),
                      ).show(context);
                      setState(() {});
                    },
                  ),
                  if (_task.didChanges(widget.task)) const EmptyBox(height: 60),
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

  void _choosePerformer() async {
    if (_users.isEmpty) return;
    User? _selectedUser = _task.performer;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: AppConstraints.borderRadius),
      builder: (context) => StatefulBuilder(
        builder: (context, childSetState) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('choose_performer'.tr()),
              const EmptyBox(height: 12.0),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _users.length,
                separatorBuilder: (context, index) => const EmptyBox(height: 12.0),
                itemBuilder: (context, index) => OneLineCell(
                  title: _users[index].name ?? _users[index].phone ?? 'User #${_users[index].id}',
                  onTap: () => childSetState(() => _selectedUser = _users[index]),
                  needIcon: true,
                  icon: _selectedUser != null && _users.indexOf(_selectedUser!) == index
                      ? const Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.success)
                      : const Icon(CupertinoIcons.circle),
                ),
              ),
              const EmptyBox(height: 16.0),
              OneLineCell(
                title: 'done'.tr(),
                onTap: () => Navigator.of(context).pop(),
                needIcon: false,
                centerTitle: true,
              ),
              const EmptyBox(),
            ],
          ),
        ),
      ),
    );
    _task = _task.copyWith(performer: _selectedUser);
    setState(() {});
  }
}
