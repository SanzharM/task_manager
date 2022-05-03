part of 'task_board_bloc.dart';

abstract class TaskBoardState extends Equatable {
  const TaskBoardState();

  @override
  List<Object> get props => [];
}

class TaskBoardInitial extends TaskBoardState {}

class Loading extends TaskBoardState {}

class BoardsLoaded extends TaskBoardState {
  final List<Board> boards;
  BoardsLoaded(this.boards);

  @override
  List<Object> get props => [boards];
}

class ErrorState extends TaskBoardState {
  final String error;
  ErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class BoardCreated extends TaskBoardState {}

class CompanyUsersLoaded extends TaskBoardState {
  final List<User> users;
  CompanyUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}
