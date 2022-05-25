part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasks extends TaskEvent {
  final int boardId;
  GetTasks(this.boardId);

  @override
  List<Object> get props => [boardId];
}

class GetTask extends TaskEvent {
  final int id;
  GetTask(this.id);

  @override
  List<Object> get props => [id];
}

class CreateTask extends TaskEvent {
  final Task task;
  CreateTask(this.task);

  @override
  List<Object> get props => [task];
}

class EditTask extends TaskEvent {
  final Task task;
  EditTask(this.task);

  @override
  List<Object> get props => [task];
}

class ValidateTask extends TaskEvent {
  final Task? task;
  ValidateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final Task task;
  DeleteTask(this.task);
}

class GetBoardUsers extends TaskEvent {
  final int boardId;
  GetBoardUsers(this.boardId);

  @override
  List<Object> get props => [boardId];
}

class GetUsers extends TaskEvent {}

class GetComments extends TaskEvent {
  final int taskId;
  GetComments(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class CreateComment extends TaskEvent {
  final String text;
  final int taskId;
  CreateComment(this.text, this.taskId);

  @override
  List<Object> get props => [text, taskId];
}
