import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/constants/app_constraints.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/widgets/app_cells.dart';
import 'package:task_manager/core/widgets/custom_shimmer.dart';
import 'package:task_manager/core/widgets/empty_box.dart';
import 'package:task_manager/core/widgets/page_routes/custom_page_route.dart';
import 'package:task_manager/pages/task_board/bloc/task_board_bloc.dart';
import 'package:task_manager/pages/task_board/ui/create_board_page.dart';
import 'package:task_manager/pages/task_board/ui/task_board_builder.dart';
import 'package:task_manager/pages/task_board/ui/task_board_drawer.dart';
import 'package:task_manager/pages/task_page/create_task_page.dart';

class TaskBoard extends StatefulWidget {
  const TaskBoard({Key? key}) : super(key: key);

  @override
  TaskBoardState createState() => TaskBoardState();
}

class TaskBoardState extends State<TaskBoard> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _boardBuilderKey = GlobalKey<TaskBoardBuilderState>();
  final _createBoardKey = GlobalKey<CreateBoardPageState>();

  final _bloc = TaskBoardBloc();

  int? _currentBoardIndex;
  List<Board> _boards = [];
  List<User> _companyUsers = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bloc.getBoards();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: TaskBoardDrawer(
        boards: _boards,
        currentBoard: _currentBoardIndex,
        onChangeBoard: _onChangeBoard,
        onCreateBoard: _toCreateBoardPage,
      ),
      appBar: AppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(Icons.menu_rounded),
          onPressed: _boards.isEmpty ? null : () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: (_boards.isNotEmpty && _currentBoardIndex != null)
            ? [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.add_circled_solid),
                  onPressed: () => Navigator.of(context).push(
                    CustomPageRoute(
                        child: CreateTaskPage(
                      board: _boards[_currentBoardIndex!],
                      task: null,
                      onBack: () => _bloc.getBoards(), // getBoard(_currentBoardIndex!),
                      users: _companyUsers,
                    )),
                  ),
                ),
                const EmptyBox(width: 16.0),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.refresh),
                  onPressed: _onRefresh,
                ),
                const EmptyBox(width: 16.0),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.settings),
                  onPressed: _showBoardSettings,
                ),
                const EmptyBox(width: 4.0),
              ]
            : null,
      ),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (context, state) async {
            print('state is $state');

            isLoading = state is Loading;

            if (state is ErrorState && (_createBoardKey.currentState?.isLoading ?? false)) {
              // await Future.delayed(const Duration(milliseconds: 450));
              _createBoardKey.currentState?.setIsLoading(false);
            }

            if (state is ErrorState) {
              AlertController.showSnackbar(context: context, message: state.error);
            }

            if (state is BoardsLoaded) {
              _boards = state.boards;
              if (_currentBoardIndex == null && _boards.isNotEmpty) _currentBoardIndex = 0;
            }

            if (state is BoardCreated) {
              _createBoardKey.currentState?.setIsLoading(false);
              Navigator.of(context).pop();
              _bloc.getBoards();
            }

            if (state is CompanyUsersLoaded) {
              _companyUsers = state.users;
            }

            setState(() {});
          },
          child: CustomShimmer(
            enabled: isLoading,
            child: TaskBoardBuilder(
              key: _boardBuilderKey,
              onCreateBoard: _toCreateBoardPage,
              onRefresh: _onRefresh,
              board: _currentBoardIndex != null ? _boards[_currentBoardIndex!] : null,
            ),
          ),
        ),
      ),
    );
  }

  void _onChangeBoard(index) {
    print('new index: $index');
    setState(() => _currentBoardIndex = index);
    Navigator.of(context).pop();
  }

  Future<void> _onRefresh() async {
    _bloc.getCompanyUsers();
    _bloc.getBoards();
    return Future.delayed(const Duration(milliseconds: 500));
  }

  void animateTabTo(int i) => _boardBuilderKey.currentState?.animateTabTo(i);

  void _toCreateBoardPage() => Navigator.of(context).push(CustomPageRoute(
        child: CreateBoardPage(onCreate: _onCreateBoard, key: _createBoardKey),
      ));

  void _onCreateBoard(String name, String? description) {
    if (name.isEmpty) return;
    _createBoardKey.currentState?.setIsLoading(true);
    if (!isLoading) return _bloc.createBoard(name, description);
  }

  void _showBoardSettings() => showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: AppConstraints.borderRadiusTLR),
        builder: (context) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order by', textAlign: TextAlign.start),
              const EmptyBox(height: 8.0),
              OneLineCell(title: 'Time', onTap: () => null),
              const EmptyBox(height: 16.0),
              OneLineCell(title: 'Status', onTap: () => null),
              const EmptyBox(height: 16.0),
              Text('Actions', textAlign: TextAlign.start),
              const EmptyBox(height: 8.0),
              OneLineCell(title: 'delete board', onTap: () => null),
              const EmptyBox(height: 24.0),
              OneLineCell(
                title: 'done',
                centerTitle: true,
                needIcon: false,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
}
