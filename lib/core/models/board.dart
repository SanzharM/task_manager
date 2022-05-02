import 'package:task_manager/core/models/task.dart';

class Board {
  final int? pk;
  final String? name;
  final String? description;
  final List<Task>? tasks;
  final List<Task>? sortedTasks;

  Board({
    this.pk,
    this.name,
    this.description,
    this.tasks,
    this.sortedTasks,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      pk: int.tryParse('${json['id']}'),
      name: json['name'],
      description: json['description'],
      tasks: json['tasks'] == null ? null : (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
    );
  }

  Board copyWith({
    String? name,
    String? description,
    List<Task>? tasks,
    List<Task>? sortedTasks,
  }) {
    return Board(
      name: name ?? this.name,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      sortedTasks: sortedTasks ?? this.sortedTasks,
    );
  }
}
