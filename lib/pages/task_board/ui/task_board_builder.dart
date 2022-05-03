import 'package:flutter/material.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/ui/task_card.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskBoardBuilder extends StatefulWidget {
  const TaskBoardBuilder({Key? key, required this.board, required this.onCreateBoard}) : super(key: key);

  final Board? board;
  final void Function() onCreateBoard;

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
    if (widget.board == null) {
      return ListView(
        children: [
          EmptyBox(height: MediaQuery.of(context).size.height * 0.33),
          GestureDetector(
            onTap: widget.onCreateBoard,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('create_new_board'.tr(), style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Text(
            widget.board?.name ?? widget.board?.description ?? 'title'.tr(),
            style: const TextStyle(fontSize: 18),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).viewPadding.top,
              minWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).viewPadding.top,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
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
        ],
      ),
    );
  }
}
