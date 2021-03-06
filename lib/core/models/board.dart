import 'package:task_manager/core/models/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_manager/core/models/user.dart';

class Board {
  final int? pk;
  final String? name;
  final String? description;
  final List<Task>? tasks;
  final List<User>? users;

  Board({
    this.pk,
    this.name,
    this.description,
    this.tasks,
    this.users,
  });

  String getTitle() {
    if (this.name != null) return this.name!;
    if (this.pk != null) return 'board'.tr() + ' #${this.pk}';
    return 'board'.tr();
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      pk: int.tryParse('${json['id']}'),
      name: json['name'],
      description: json['description'],
      users: json['users'] == null ? null : (json['users'] as List).map((e) => User.fromJson(e)).toList(),
      tasks: json['tasks'] == null ? null : (json['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
    );
  }

  Board copyWith({
    String? name,
    String? description,
    List<Task>? tasks,
  }) {
    return Board(
      name: name ?? this.name,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.pk,
        'name': this.name,
        'description': this.description,
      };
}
