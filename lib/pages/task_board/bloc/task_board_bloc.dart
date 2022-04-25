import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:easy_localization/easy_localization.dart';

part 'task_board_event.dart';
part 'task_board_state.dart';

class TaskBoardBloc extends Bloc<TaskBoardEvent, TaskBoardState> {
  getBoards() => add(GetBoards());
  createBoard(String name, String? description) => add(CreateBoard(name: name, description: description));

  TaskBoardBloc() : super(TaskBoardInitial()) {
    on<GetBoards>((event, emit) async {
      emit(TaskBoardInitial());
      emit(Loading());
      final response = await ApiClient.getBoards();

      if (response.boards != null) {
        return emit(BoardsLoaded(response.boards!));
      } else {
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
  }
}
