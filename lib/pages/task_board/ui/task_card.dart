import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/pages/task_page/task_page.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard(this.task);

  static Widget getCardContainer(BuildContext context, {double opacity = 0.5}) {
    return Container(
      constraints: BoxConstraints(minHeight: 60, minWidth: 90),
      height: MediaQuery.of(context).size.height * 128 / 1000,
      width: MediaQuery.of(context).size.width - 16.0,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      color: AppColors.metal.withOpacity(opacity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => TaskPage(task))),
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
    );
  }
}

class TaskCards extends StatelessWidget {
  final List<Task> tasks;
  const TaskCards({required this.tasks});

  static const _style = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty)
      return const Center(
        child: Text('Задач в этой секции нет', style: _style),
      );

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(tasks[index]);
      },
    );
  }
}
