part of 'task_board_bloc.dart';

abstract class TaskBoardEvent extends Equatable {
  const TaskBoardEvent();

  @override
  List<Object> get props => [];
}

class GetBoards extends TaskBoardEvent {
  @override
  List<Object> get props => [];
}

class CreateBoard extends TaskBoardEvent {
  final String name;
  final String? description;
  CreateBoard({required this.name, this.description});

  @override
  List<Object> get props => [];
}
