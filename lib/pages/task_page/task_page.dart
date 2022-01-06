import 'package:flutter/material.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage(this.task);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Task _task;

  @override
  void initState() {
    _task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String deadline = Utils.dateToString(_task.deadline);
    if (deadline.isEmpty) deadline = '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(_task.title ?? 'Задача'),
        centerTitle: true,
        leading: AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                EmptyBox(height: 16),
                TaskRow(title: 'Назначено: ', value: _task.creator?.name),
                EmptyBox(height: 12),
                TaskRow(title: 'Исполнитель: ', value: _task.performer?.name),
                EmptyBox(height: 12),
                TaskRow(
                  title: 'Статус: ',
                  value: Utils.taskStatusToString(_task.status),
                ),
                EmptyBox(height: 12),
                TaskRow(
                  title: 'Дата создания: ',
                  value: Utils.dateToString(_task.createdAt),
                ),
                EmptyBox(height: 12),
                TaskRow(title: 'Крайний срок выполнения: ', value: deadline),
                EmptyBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Описание:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                EmptyBox(height: 8),
                Text(
                  _task.description ?? '-',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  final String title;
  final String? value;
  const TaskRow({required this.title, required this.value});

  static const _titleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const _valueStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: _titleStyle),
        EmptyBox(width: 4.0),
        Text(
          value != null && value!.isNotEmpty ? value! : '-',
          style: _valueStyle,
        ),
      ],
    );
  }
}
