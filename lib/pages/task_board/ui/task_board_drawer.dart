import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskBoardDrawer extends StatelessWidget {
  const TaskBoardDrawer({
    Key? key,
    required this.boards,
    required this.currentBoard,
    required this.onChangeBoard,
    required this.onCreateBoard,
  }) : super(key: key);

  final List<Board?> boards;
  final int? currentBoard;
  final void Function(int index) onChangeBoard;
  final void Function() onCreateBoard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: AppBar().preferredSize.height),
      color: Theme.of(context).scaffoldBackgroundColor,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
        maxHeight: MediaQuery.of(context).size.height,
        minWidth: MediaQuery.of(context).size.width * 0.75,
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Column(
        children: [
          Text(
            'your_boards'.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: CupertinoScrollbar(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                itemCount: boards.length,
                separatorBuilder: (context, index) => const EmptyBox(height: 8.0),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Column(
                      children: [
                        OneLineCell(
                          title: '+ New Board',
                          onTap: onCreateBoard,
                          needIcon: false,
                        ),
                        const EmptyBox(height: 8.0),
                        OneLineCell(
                          title: 'board'.tr() + ' #${i + 1}',
                          onTap: () => onChangeBoard(i),
                          icon: currentBoard == i
                              ? const Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.success)
                              : const Icon(CupertinoIcons.forward),
                        ),
                      ],
                    );
                  }
                  return OneLineCell(
                    title: 'board'.tr() + ' #${i + 1}',
                    onTap: () => onChangeBoard(i),
                    icon: currentBoard == i
                        ? const Icon(CupertinoIcons.check_mark_circled_solid, color: AppColors.success)
                        : const Icon(CupertinoIcons.forward),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
