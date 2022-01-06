import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/pages/task_page/task_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard(this.task);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => TaskPage(task))),
      child: Container(
        constraints: BoxConstraints(minHeight: 60, minWidth: 90),
        height: MediaQuery.of(context).size.height * 128 / 1000,
        width: MediaQuery.of(context).size.width - 16.0,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Application.isDarkMode(context)
              ? AppColors.grey
              : AppColors.defaultGrey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                task.title ?? 'Задача',
                maxLines:
                    task.description != null && task.description!.isNotEmpty
                        ? 1
                        : null,
                overflow: TextOverflow.fade,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            if (task.description != null && task.description!.isNotEmpty)
              Expanded(child: Text(task.description!))
          ],
        ),
      ),
    );
  }
}
