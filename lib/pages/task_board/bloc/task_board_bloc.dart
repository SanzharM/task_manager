import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/models/user.dart';

part 'task_board_event.dart';
part 'task_board_state.dart';

class TaskBoardBloc extends Bloc<TaskBoardEvent, TaskBoardState> {
  getBoards() => add(GetBoards());
  createBoard(String name, String? description) => add(CreateBoard(name: name, description: description));
  getCompanyUsers() => add(GetCompanyUsers());

  TaskBoardBloc() : super(TaskBoardInitial()) {
    on<GetBoards>((event, emit) async {
      emit(TaskBoardInitial());
      emit(Loading());
      final response = await ApiClient.getBoards();

      if (response.boards != null) {
        print('returning boards');
        return emit(BoardsLoaded(response.boards!));
      } else {
        print('returning error');
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<CreateBoard>((event, emit) async {
      emit(TaskBoardInitial());
      emit(Loading());
      final response = await ApiClient.createBoard(name: event.name, description: event.description);

      if (response.success == true) {
        return emit(BoardCreated());
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<GetCompanyUsers>((event, emit) async {
      emit(TaskBoardInitial());
      emit(Loading());

      final response = await ApiClient.getCompanyUsers();

      if (response.users != null) {
        return emit(CompanyUsersLoaded(response.users!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });
  }
}
