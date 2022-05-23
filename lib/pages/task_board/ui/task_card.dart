import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/date_picker.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/ui/task_board_builder.dart';
import 'package:task_manager/pages/task_page/task_page.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key? key,
    required this.task,
    required this.onBack,
    required this.onEditTask,
    required this.deleteTask,
  }) : super(key: key);

  final Task task;
  final void Function() onBack;
  final void Function(Task) onEditTask;
  final void Function(Task) deleteTask;

  static Widget getCardContainer(BuildContext context, {double opacity = 0.5}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60, minWidth: 90),
      height: MediaQuery.of(context).size.height * 128 / 1000,
      width: MediaQuery.of(context).size.width - 16.0,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      color: AppColors.metal.withOpacity(opacity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final difference = task.deadline?.difference(DateTime.now()).inDays;
    return CupertinoButton(
      key: key,
      padding: EdgeInsets.zero,
      pressedOpacity: 0.75,
      onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TaskPage(task, onBack: onBack))),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: AppConstraints.borderRadius,
          border: Border.all(color: Application.isDarkMode(context) ? AppColors.defaultGrey.withOpacity(0.5) : AppColors.grey),
          color: Utils.getColorFromStatus(task.status, context),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? 'task'.tr(),
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const EmptyBox(height: 8.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(CupertinoIcons.person_fill),
                          const EmptyBox(width: 8.0),
                          Flexible(
                            child: Text(
                              task.performer?.name ?? task.performer?.phone ?? 'No performer',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const EmptyBox(height: 8.0),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.time_solid),
                          const EmptyBox(width: 8.0),
                          Text(Utils.toDateString(task.deadline), style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const EmptyBox(height: 8.0),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => _showActions(context),
                    child: Container(
                      color: AppColors.white.withOpacity(0.01),
                      child: Icon(CupertinoIcons.chevron_down),
                    ),
                  ),
                ),
              ],
            ),
            if (difference != null && difference < 7 && task.status != TaskStatus.done)
              Container(
                width: double.maxFinite.abs(),
                height: 2.0,
                decoration: BoxDecoration(
                  borderRadius: AppConstraints.borderRadius,
                  color: AppColors.error,
                ),
              ),
            if (difference != null && difference < 7 && task.status != TaskStatus.done)
              Align(
                alignment: Alignment.bottomRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: (MediaQuery.of(context).size.width * ((difference.isNegative ? 0 : difference) / 7)).abs(),
                  height: 2.0,
                  color: AppColors.defaultGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context) async {
    TaskStatus _status = task.status ?? TaskStatus.undetermined;
    Task _editedTask = task.copyWith(status: _status);
    bool didChanges = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: AppConstraints.borderRadiusTLR),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height * 0.87,
        ),
        child: StatefulBuilder(
          builder: (context, childSetState) => GestureDetector(
            onTap: FocusScope.of(context).hasFocus ? () => FocusScope.of(context).unfocus() : null,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('status'.tr(), textAlign: TextAlign.start),
                  const EmptyBox(height: 8.0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: TaskStatus.values.length,
                    separatorBuilder: (context, index) => const EmptyBox(height: 12.0),
                    itemBuilder: (context, index) => OneLineCell(
                      title: 'status_${TaskStatus.values[index].toString().split('.').last}'.tr(),
                      onTap: () => childSetState(() {
                        _status = TaskStatus.values[index];
                        if (!didChanges) didChanges = true;
                      }),
                      icon: index == _status.index
                          ? const Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.success)
                          : const Icon(CupertinoIcons.circle),
                    ),
                  ),
                  const EmptyBox(height: 16.0),
                  Text('deadline'.tr()),
                  const EmptyBox(height: 8.0),
                  OneLineCell(
                    title: Utils.dateToString(_editedTask.deadline),
                    icon: const Icon(CupertinoIcons.time),
                    onTap: () => DatePicker(
                      minDate: _editedTask.createdAt?.subtract(Duration(days: 365)),
                      initialDate: _editedTask.deadline,
                      onPicked: (date) => childSetState(() {
                        _editedTask = _editedTask.copyWith(deadline: Utils.parseOnlyDate(date));
                        if (!didChanges) didChanges = true;
                      }),
                    ).show(context),
                  ),
                  const EmptyBox(height: 16.0),
                  Text('delete'.tr()),
                  const EmptyBox(height: 8.0),
                  OneLineCell(
                    title: 'delete'.tr(),
                    centerTitle: false,
                    icon: const Icon(CupertinoIcons.delete, color: AppColors.lightRed),
                    onTap: () {
                      deleteTask(task);
                      Navigator.of(context).pop();
                    },
                  ),
                  const EmptyBox(height: 24.0),
                  OneLineCell(
                    title: 'done'.tr(),
                    centerTitle: true,
                    needIcon: false,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (didChanges || _status != task.status) {
      onEditTask(_editedTask.copyWith(status: _status));
    }
  }
}

class TaskCards extends StatelessWidget {
  const TaskCards({
    Key? key,
    required this.tasks,
    required this.columnStatus,
    required this.timeSort,
    this.orderByStatus = true,
    required this.onEditTask,
    required this.onBack,
    required this.deleteTask,
  }) : super(key: key);

  final List<Task> tasks;
  final TaskStatus columnStatus;
  final TimeSort timeSort;
  final bool orderByStatus;
  final void Function() onBack;
  final void Function(Task) onEditTask;
  final void Function(Task) deleteTask;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty)
      return Center(
        child: Text(
          'no_tasks_in_section'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );

    int emptyCards = 0;
    tasks.forEach((e) {
      if (orderByStatus) {
        if (e.status != columnStatus) emptyCards += 1;
      } else {
        if (!Utils.isBelongingToTimeSort(timeSort: timeSort, deadline: e.deadline)) emptyCards += 1;
      }
    });
    if (emptyCards == tasks.length)
      return Center(
        child: Text(
          'no_tasks_in_section'.tr(),
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      );
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        if (orderByStatus) {
          if (tasks[index].status != columnStatus) return const EmptyBox();
          return TaskCard(
            task: tasks[index],
            onBack: onBack,
            onEditTask: onEditTask,
            deleteTask: deleteTask,
          );
        }
        // if (tasks[index].deadline == null) {
        //   return const EmptyBox();
        // }

        if (Utils.isBelongingToTimeSort(timeSort: timeSort, deadline: tasks[index].deadline)) {
          return TaskCard(
            task: tasks[index],
            onBack: onBack,
            onEditTask: onEditTask,
            deleteTask: deleteTask,
          );
        } else {
          return const EmptyBox();
        }
      },
    );
  }
}
