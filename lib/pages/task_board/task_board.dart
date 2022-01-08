import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/task_card.dart';

class TaskBoard extends StatefulWidget {
  const TaskBoard({Key? key}) : super(key: key);
  @override
  TaskBoardState createState() => TaskBoardState();
}

class TaskBoardState extends State<TaskBoard> with TickerProviderStateMixin {
  late TabController _boardTabController;

  List<Task> _toDoTasks = [
    Task(title: 'ToDo task 1'),
    Task(title: 'ToDo task 2', description: 'delai kracuBo'),
    Task(title: 'ToDo task 3'),
    Task(title: 'ToDo task 4'),
  ];
  List<Task> _inWorkTasks = [
    Task(title: 'in work task 1'),
    Task(title: 'in work task 2'),
  ];
  List<Task> _toTestTasks = [
    // Task(title: 'toTest task 1'),
  ];
  List<Task> _doneTasks = [
    Task(title: 'done task 1 '),
    Task(
      title:
          'done task 2 donedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedone',
      description:
          'donedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedonedone',
    ),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
  ];

  void animateTabTo(int index) => _boardTabController.animateTo(index);

  @override
  void initState() {
    _boardTabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _boardTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: AppColors.metal,
            constraints: constraints,
            child: Column(
              children: [
                EmptyBox(height: 56),
                TabBar(
                  controller: _boardTabController,
                  isScrollable: true,
                  physics: BouncingScrollPhysics(),
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: 'К выполнению'),
                    Tab(text: 'В работе'),
                    Tab(text: 'На проверке'),
                    Tab(text: 'Готово'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _boardTabController,
                    physics: BouncingScrollPhysics(),
                    children: [
                      TaskCards(tasks: _toDoTasks),
                      TaskCards(tasks: _inWorkTasks),
                      TaskCards(tasks: _toTestTasks),
                      TaskCards(tasks: _doneTasks),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(tasks[index]);
      },
    );
  }
}
