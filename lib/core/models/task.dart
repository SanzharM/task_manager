import 'package:task_manager/core/models/user.dart';

enum TaskStatus { to_do, in_work, test, done, undetermined }

class Task {
  int? pk;
  String? title;
  String? description;
  dynamic content;
  DateTime? deadline;
  TaskStatus? status;
  DateTime? createdAt;
  DateTime? lastUpdatedAt;
  int? boardId;
  User? creator;
  User? performer;

  Task({
    this.pk,
    this.title,
    this.description,
    this.content,
    this.deadline,
    this.status,
    this.createdAt,
    this.lastUpdatedAt,
    this.boardId,
    this.creator,
    this.performer,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task();
  }

  Task copyWith({
    String? title,
    String? description,
    dynamic content,
    DateTime? deadline,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    int? boardId,
    User? creator,
    User? performer,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      boardId: boardId ?? this.boardId,
      creator: creator ?? this.creator,
      performer: performer ?? this.performer,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.pk,
        'title': this.title,
        'description': this.description,
        'deadline': this.deadline?.toIso8601String(),
        'board_id': this.boardId,
        'status': 'TODO',
      };
}
