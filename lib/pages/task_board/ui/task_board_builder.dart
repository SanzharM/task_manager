import 'package:flutter/material.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/ui/task_card.dart';

class TaskBoardBuilder extends StatefulWidget {
  const TaskBoardBuilder({Key? key, required this.board}) : super(key: key);

  final Board? board;

  @override
  State<TaskBoardBuilder> createState() => TaskBoardBuilderState();
}

class TaskBoardBuilderState extends State<TaskBoardBuilder> with SingleTickerProviderStateMixin {
  final _boardTabController = ScrollController();

  void animateTabTo({double? to}) => _boardTabController.animateTo(
        to ?? _boardTabController.position.minScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _boardTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const EmptyBox(height: 16.0),
          if (widget.board == null)
            GestureDetector(
              onTap: () => null,
              child: const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('create a new board'))),
            ),
          Text(
            widget.board?.name ?? widget.board?.description ?? 'board title',
            style: const TextStyle(fontSize: 18),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: widget.board?.tasks?.length ?? 0,
              itemBuilder: (context, i) {
                final _task = widget.board!.tasks![i];
                return Column(
                  children: [
                    Text('${_task.title}'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => TaskCard(_task),
                    ),
                  ],
                );
              },
            ),
          ),
          // Theme(
          //   data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
          //   child: TabBar(
          //     controller: _boardTabController,
          //     isScrollable: true,
          //     physics: const BouncingScrollPhysics(),
          //     labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          //     enableFeedback: true,
          //     tabs: const [
          //       // Tab(text: 'К выполнению'),
          //       // Tab(text: 'В работе'),
          //       // Tab(text: 'На проверке'),
          //       // Tab(text: 'Готово'),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: MediaQuery.of(context).size.height,
          //   child: TabBarView(
          //     controller: _boardTabController,
          //     physics: const BouncingScrollPhysics(),
          //     children: [
          // TaskCards(tasks: _toDoTasks),
          // TaskCards(tasks: _inWorkTasks),
          // TaskCards(tasks: _toTestTasks),
          // TaskCards(tasks: _doneTasks),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
