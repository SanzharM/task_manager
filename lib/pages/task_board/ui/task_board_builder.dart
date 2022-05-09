import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/widgets/app_buttons.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/pages/task_board/ui/task_card.dart';
import 'package:easy_localization/easy_localization.dart';

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

  void animateTabTo(int index) =>
      _boardTabController.animateTo(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);

  @override
  void initState() {
    super.initState();
    _boardTabController = TabController(length: 5, vsync: this);
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

    return Column(
      children: [
        TabBar(
          physics: const BouncingScrollPhysics(),
          controller: _boardTabController,
          isScrollable: true,
          tabs: [
            for (int i = 0; i < 5; i++) Tab(text: getTaskColumnTitle(i)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _boardTabController,
            physics: const BouncingScrollPhysics(),
            children: [
              TaskCards(tasks: widget.board!.tasks!),
              TaskCards(tasks: widget.board!.tasks!),
              TaskCards(tasks: widget.board!.tasks!),
              TaskCards(tasks: widget.board!.tasks!),
              TaskCards(tasks: widget.board!.tasks!),
            ],
          ),
        ),
      ],
    );
  }

  String getTaskColumnTitle(int index) {
    switch (index) {
      case 0:
        return 'past_tasks'.tr();
      case 1:
        return 'week'.tr();
      case 2:
        return 'month'.tr();
      case 3:
        return 'month+'.tr();
      default:
        return 'out_of_deadline'.tr();
    }
  }
}
