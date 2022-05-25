part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class Loading extends TaskState {}

class ErrorState extends TaskState {
  final String error;
  ErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class TaskCreated extends TaskState {
  @override
  List<Object> get props => [];
}

class TaskLoaded extends TaskState {
  final Task task;
  TaskLoaded(this.task);

  @override
  List<Object> get props => [task];
}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskEdited extends TaskState {
  final Task task;
  TaskEdited(this.task);

  @override
  List<Object> get props => [task];
}

class BoardUsersLoaded extends TaskState {
  final List<User> users;
  BoardUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class TaskDeleted extends TaskState {
  final Task task;
  TaskDeleted(this.task);

  @override
  List<Object> get props => [task];
}

class UsersLoaded extends TaskState {
  final List<User> users;
  UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class CommentsLoading extends TaskState {}

class CommentsLoaded extends TaskState {
  final List<Comment> comments;
  CommentsLoaded(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentCreated extends TaskState {
  final Comment comment;
  CommentCreated(this.comment);

  @override
  List<Object> get props => [comment];
}
