import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/custom_stepper.dart' as stepper;
import 'package:task_manager/core/widgets/date_picker.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/core/widgets/text_fields.dart';
import 'package:task_manager/core/widgets/user_card.dart';
import 'package:task_manager/core/widgets/value_picker.dart';
import 'package:task_manager/pages/task_page/bloc/task_bloc.dart';
import 'package:task_manager/pages/task_page/comments_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(this.task, {Key? key, this.users, this.onBack}) : super(key: key);

  final Task task;
  final List<User>? users;
  final void Function()? onBack;

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with TickerProviderStateMixin {
  final _bloc = TaskBloc();
  late Task _task;

  List<User> _users = [];

  bool isLoading = false;
  bool isTextExpanded = false;
  bool isCommentsLoading = false;

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
    if (_task.pk != null) _bloc.getComments(_task.pk!);
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
            print('state is $state');
            isLoading = state is Loading;
            if (state is CommentsLoading) isCommentsLoading = true;

            if (state is ErrorState) {
              isCommentsLoading = false;
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
                    text: _task.description,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    readonly: true,
                    onTap: () => setState(() {}),
                    onChanged: (value) => setState(() => _task = _task.copyWith(title: value)),
                  ),
                  const EmptyBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.grey.withOpacity(0.33)),
                      borderRadius: AppConstraints.borderRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: AppConstraints.borderRadius,
                      child: ExpansionTile(
                        title: Text('description'.tr()),
                        textColor: Theme.of(context).primaryColor,
                        iconColor: Theme.of(context).primaryColor,
                        childrenPadding: const EdgeInsets.symmetric(vertical: 12.0),
                        children: [
                          Text(
                            _task.description ?? '',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const EmptyBox(height: 12),
                  stepper.CustomStepper(
                    physics: const NeverScrollableScrollPhysics(),
                    controlsBuilder: (context, details) => const EmptyBox(),
                    steps: [
                      stepper.Step(
                        state: stepper.StepState.complete,
                        isActive: true,
                        content: const EmptyBox(),
                        title: CupertinoButton(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: UserRow(user: _task.creator, size: 48.0, namePlaceholder: 'No creator'),
                          onPressed: null,
                        ),
                        subtitle: CupertinoButton(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text('created_date'.tr() + ': ' + Utils.toDateString(_task.createdAt)),
                          onPressed: null,
                        ),
                      ),
                      stepper.Step(
                        state: _task.status == TaskStatus.done ? stepper.StepState.complete : stepper.StepState.editing,
                        isActive: _task.status == TaskStatus.done,
                        content: const EmptyBox(),
                        title: CupertinoButton(
                          padding: const EdgeInsets.only(top: 16.0),
                          onPressed: _choosePerformer,
                          child: UserRow(user: _task.performer, size: 48.0, namePlaceholder: 'No performer'),
                        ),
                        subtitle: CupertinoButton(
                          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Text('deadline'.tr() + ': ' + Utils.toDateString(_task.deadline)),
                          onPressed: () async {
                            await DatePicker(
                              minDate: Utils.getOnlyDate(_task.createdAt),
                              initialDate: _task.deadline,
                              onPicked: (date) => setState(() => _task = _task.copyWith(deadline: date)),
                            ).show(context);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  const EmptyBox(height: 12),
                  OneLineCell(
                    title: 'status'.tr() + ': ' + Utils.taskStatusToString(_task.status),
                    leading: const Icon(CupertinoIcons.square_list_fill),
                    onTap: _changeStatus,
                  ),
                  const EmptyBox(height: 12),
                  OneLineCell(
                    title: 'comments'.tr(),
                    leading: const Icon(Icons.comment),
                    icon: const Icon(CupertinoIcons.forward),
                    onTap: () {
                      if (_task.pk == null) return;
                      Navigator.of(context).push(CustomPageRoute(
                        direction: AxisDirection.up,
                        child: CommentsPage(taskId: _task.pk!),
                      ));
                      return;
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
                color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
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
