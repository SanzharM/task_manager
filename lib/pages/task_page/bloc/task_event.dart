part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasks extends TaskEvent {}

class CreateTask extends TaskEvent {
  final Task task;
  CreateTask(this.task);
}

class EditTask extends TaskEvent {}

class ValidateTask extends TaskEvent {
  final Task? task;
  ValidateTask(this.task);
}

class GetBoardUsers extends TaskEvent {
  final int boardId;
  GetBoardUsers(this.boardId);
}
