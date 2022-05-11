import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/utils.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/ui/task_card.dart';
import 'package:easy_localization/easy_localization.dart';

enum SortOrder { time, status }

enum TimeSort { week, month, past_tasks, out_of_deadline }

class TaskBoardBuilder extends StatefulWidget {
  const TaskBoardBuilder({
    Key? key,
    required this.board,
    required this.onCreateBoard,
    required this.onRefresh,
  }) : super(key: key);

  final Board? board;
  final void Function() onCreateBoard;
  final Future<void> Function() onRefresh;

  @override
  State<TaskBoardBuilder> createState() => TaskBoardBuilderState();
}

class TaskBoardBuilderState extends State<TaskBoardBuilder> with SingleTickerProviderStateMixin {
  late TabController _boardTabController;
  SortOrder order = SortOrder.time;

  List<dynamic> tabList = [];

  void animateTabTo(int index) =>
      _boardTabController.animateTo(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);

  Future<void> getSortOrder() async {
    final value = await Application.getBoardSortOrder();
    if (value == SortOrder.status) {
      tabList = TaskStatus.values;
    }
    if (value == SortOrder.time) {
      tabList = TimeSort.values;
    }
    setState(() => order = value);
  }

  @override
  void initState() {
    super.initState();
    getSortOrder().then((value) => _boardTabController = TabController(vsync: this, length: tabList.length));
  }

  @override
  void dispose() {
    _boardTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.board == null) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        backgroundColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.grey,
        color: Application.isDarkMode(context) ? AppColors.grey : AppColors.metal,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            EmptyBox(height: MediaQuery.of(context).size.height * 0.33),
            AppButton(
              onTap: widget.onCreateBoard,
              title: 'create_new_board'.tr(),
              needBorder: true,
            ),
          ],
        ),
      );
    }

    print('\n\nSORT ORDER: $order');

    if (order == SortOrder.status) {
      return Column(
        children: [
          TabBar(
            physics: const BouncingScrollPhysics(),
            controller: _boardTabController,
            isScrollable: true,
            indicatorColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.darkGrey,
            tabs: [
              for (var status in TaskStatus.values) Tab(text: Utils.taskStatusToString(status)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _boardTabController,
              physics: const BouncingScrollPhysics(),
              children: [
                for (var status in TaskStatus.values)
                  TaskCards(
                    tasks: widget.board!.tasks!,
                    columnStatus: status,
                    timeSort: TimeSort.month,
                    orderByStatus: true,
                  ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        TabBar(
          physics: const BouncingScrollPhysics(),
          controller: _boardTabController,
          isScrollable: true,
          indicatorColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.darkGrey,
          tabs: [
            for (var time in TimeSort.values) Tab(text: Utils.getStringTimeSort(time)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _boardTabController,
            physics: const BouncingScrollPhysics(),
            children: [
              for (var time in TimeSort.values)
                TaskCards(
                  tasks: widget.board!.tasks!,
                  columnStatus: TaskStatus.undetermined,
                  timeSort: time,
                  orderByStatus: false,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
