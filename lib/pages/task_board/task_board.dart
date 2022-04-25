import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/bloc/task_board_bloc.dart';
import 'package:task_manager/pages/task_board/task_card.dart';

class TaskBoard extends StatefulWidget {
  const TaskBoard({Key? key}) : super(key: key);
  @override
  TaskBoardState createState() => TaskBoardState();
}

class TaskBoardState extends State<TaskBoard> with TickerProviderStateMixin {
  late TabController _boardTabController;
  final _bloc = TaskBoardBloc();

  List<Task> _toDoTasks = [
    Task(title: 'ToDo task 1'),
    Task(title: 'Production bug fix', description: '500 server error response on these APIs: ...'),
    Task(title: 'Redesign of Application'),
    Task(title: 'Connecting Firebase Analytics'),
  ];
  List<Task> _inWorkTasks = [
    Task(title: 'Changing registration APIs from v1 to v2'),
    Task(title: 'Back-end code refactoring'),
  ];
  List<Task> _toTestTasks = [
    // Task(title: 'toTest task 1'),
  ];
  List<Task> _doneTasks = [
    Task(title: 'done task 1'),
    Task(title: 'done task 2', description: '1'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
    Task(title: 'done task 3'),
  ];

  void animateTabTo(int index) => _boardTabController.animateTo(index);

  @override
  void initState() {
    super.initState();
    _boardTabController = TabController(length: 4, vsync: this);
    _bloc.getBoards();
  }

  @override
  void dispose() {
    _boardTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            print('state is $state');
            if (state is BoardsLoaded) {}

            if (state is ErrorState) {
              if (Utils.isUnauthorizedStatusCode(state.error)) {
                AlertController.showSimpleDialog(
                  context: context,
                  message: state.error,
                  barrierDismissible: false,
                  onPressed: () => Application.clearStorage(context: context),
                );
              }
            }

            if (state is BoardCreated) _bloc.getBoards();

            setState(() {});
          },
          child: Column(
            children: [
              const EmptyBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [IconButton(onPressed: () => _bloc.createBoard('test', 'asdasd'), icon: const Icon(CupertinoIcons.add))],
              ),
              Theme(
                data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
                child: TabBar(
                  controller: _boardTabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  enableFeedback: true,
                  tabs: const [
                    Tab(text: 'К выполнению'),
                    Tab(text: 'В работе'),
                    Tab(text: 'На проверке'),
                    Tab(text: 'Готово'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _boardTabController,
                  physics: const BouncingScrollPhysics(),
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
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(tasks[index]);
      },
    );
  }
}
