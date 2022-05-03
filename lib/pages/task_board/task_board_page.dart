import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/alert_controller.dart';
import 'package:task_manager/core/app_colors.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';
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
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          if (_boards.isNotEmpty && _currentBoardIndex != null)
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(CupertinoIcons.add_circled_solid),
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
        ],
      ),
      body: SafeArea(
        child: BlocListener(
          bloc: _bloc,
          listener: (context, state) {
            print('state is $state');

            isLoading = state is Loading;

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

            if (state is BoardsLoaded) {
              print(state.boards);
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
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            backgroundColor: Application.isDarkMode(context) ? AppColors.metal : AppColors.grey,
            color: Application.isDarkMode(context) ? AppColors.grey : AppColors.metal,
            child: TaskBoardBuilder(
              key: _boardBuilderKey,
              onCreateBoard: _toCreateBoardPage,
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

  void animateTabTo({double? to}) => _boardBuilderKey.currentState?.animateTabTo(to: to);

  void _toCreateBoardPage() => Navigator.of(context).push(CustomPageRoute(child: CreateBoardPage(onCreate: _onCreateBoard)));

  void _onCreateBoard(String name, String? description) {
    if (name.isEmpty) return;
    _createBoardKey.currentState?.setIsLoading(true);
    if (!isLoading) return _bloc.createBoard(name, description);
  }
}
