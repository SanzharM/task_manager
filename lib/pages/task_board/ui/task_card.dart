import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/value_picker.dart';
import 'package:task_manager/pages/task_board/ui/task_board_builder.dart';
import 'package:task_manager/pages/task_page/bloc/task_bloc.dart';
import 'package:task_manager/pages/task_page/task_page.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task, required this.animateTabAfterLoading}) : super(key: key);

  final Task task;
  final void Function(int) animateTabAfterLoading;

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
    return CupertinoButton(
      key: key,
      padding: EdgeInsets.zero,
      pressedOpacity: 0.75,
      onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TaskPage(task))),
      child: Container(
        constraints: const BoxConstraints(minHeight: 60, minWidth: 90),
        height: MediaQuery.of(context).size.height * 128 / 1000,
        width: MediaQuery.of(context).size.width - 16.0,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: AppConstraints.borderRadius,
          color: Application.isDarkMode(context) ? AppColors.darkAction : AppColors.lightAction,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title ?? 'task'.tr(),
                      maxLines: task.description != null && task.description!.isNotEmpty ? 1 : null,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (task.description != null && task.description!.isNotEmpty) Expanded(child: Text(task.description!))
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: BlocConsumer(
                bloc: TaskBloc(),
                listener: (context, state) {
                  if (state is ErrorState) AlertController.showResultDialog(context: context, message: state.error);

                  if (state is TaskEdited) animateTabAfterLoading(state.task.status?.index ?? 0);
                },
                builder: (context, state) {
                  if (state is Loading) return CupertinoActivityIndicator();

                  return GestureDetector(
                    onTap: () => _changeStatus(
                      context: context,
                      onSelect: (value) {
                        final _editedTask = task.copyWith(status: Utils.getStatusFromString(value));
                        TaskBloc().editTask(_editedTask);
                      },
                    ),
                    child: Container(
                      color: AppColors.white.withOpacity(0.01),
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Icon(CupertinoIcons.chevron_down),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeStatus({
    required BuildContext context,
    required void Function(dynamic value) onSelect,
  }) =>
      ValuePicker(
        context: context,
        title: 'status'.tr(),
        values: TaskStatus.values.map((e) => e.toString().split('.').last).toList(),
        needTranslateValue: true,
        onSelect: (value) {
          print(value);
          onSelect(value);
          // _task = _task.copyWith(status: Utils.getStatusFromString(value));
          // setState(() {});
        },
      ).show();
}

class TaskCards extends StatelessWidget {
  const TaskCards({
    Key? key,
    required this.tasks,
    required this.columnStatus,
    required this.timeSort,
    this.orderByStatus = true,
    this.animateTabAfterLoading,
  }) : super(key: key);

  final List<Task> tasks;
  final TaskStatus columnStatus;
  final TimeSort timeSort;
  final bool orderByStatus;
  final void Function(int)? animateTabAfterLoading;

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
            animateTabAfterLoading: animateTabAfterLoading ?? (i) {},
          );
        }
        // if (tasks[index].deadline == null) {
        //   return const EmptyBox();
        // }
        return TaskCard(
          task: tasks[index],
          animateTabAfterLoading: animateTabAfterLoading ?? (i) {},
        );
      },
    );
  }
}
