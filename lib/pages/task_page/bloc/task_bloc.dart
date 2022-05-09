import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/api/api_client.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/models/user.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  getTasks(int taskId) => add(GetTasks(taskId));
  validateTask(Task? task) => add(ValidateTask(task));
  createTask(Task task) => add(CreateTask(task));

  TaskBloc() : super(TaskInitial()) {
    on<GetTask>((event, emit) async {
      emit(TaskInitial());
      emit(Loading());

      final response = await ApiClient.getTask(event.id);

      if (response.task != null) {
        return emit(TaskLoaded(response.task!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<GetTasks>((event, emit) async {
      emit(TaskInitial());
      emit(Loading());

      final response = await ApiClient.getTasks(event.boardId);

      if (response.tasks != null) {
        return emit(TasksLoaded(response.tasks!));
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });

    on<ValidateTask>((event, emit) {
      emit(TaskInitial());
      if (event.task == null) {
        return emit(ErrorState('task_cannot_be_empty'.tr()));
      }
      if (event.task?.title == null || (event.task?.title?.isEmpty ?? true)) {
        return emit(ErrorState('title_cannot_be_null'));
      }
      if (event.task?.boardId == null) {
        return emit(ErrorState('board_id_cannot_be_null'));
      }
      if (event.task?.creator?.id == null) {
        return emit(ErrorState('creator_id_cannot_be_null'));
      }
      // if (event.task?.deadline == null) {
      //   return emit(ErrorState('deadline_cannot_be_null'));
      // }
      createTask(event.task!);
    });

    on<CreateTask>((event, emit) async {
      emit(TaskInitial());
      emit(Loading());

      final response = await ApiClient.createTask(event.task);

      if (response.success == true) {
        return emit(TaskCreated());
      } else {
        return emit(ErrorState(response.error ?? 'error'.tr()));
      }
    });
  }
}
