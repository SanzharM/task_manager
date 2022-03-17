import 'package:task_manager/core/models/task.dart';

class Board {
  int? pk;
  String? name;
  String? description;
  List<Task>? tasks;

  Board({
    this.pk,
    this.name,
    this.description,
    this.tasks,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board();
  }
}
