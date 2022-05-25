import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';

class Comment {
  int? id;
  Task? task;
  User? user;
  String? content;
  DateTime? createdAt;

  Comment({this.id, this.task, this.user, this.content, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: int.tryParse('${json['id']}'),
      task: json['task'] == null ? null : Task.fromJson(json['task']),
      user: json['user'] == null ? null : User.fromJson(json['user']),
      content: json['content'],
      createdAt: Utils.parseDate('${json['date']}'),
    );
  }

  Comment copyWith({String? content, Task? task, User? user}) {
    return Comment(
      id: this.id,
      createdAt: this.createdAt,
      content: content ?? this.content,
      task: task ?? this.task,
      user: user ?? this.user,
    );
  }
}
