import 'package:task_manager/core/models/comment.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/utils.dart';

enum TaskStatus { todo, in_process, done, undetermined }

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
  List<Comment>? comments;

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
    this.comments,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      pk: int.tryParse('${json['id']}'),
      title: json['title'],
      description: json['description'],
      status: Utils.getStatusFromString('${json['status'] ?? ''}'),
      deadline: Utils.parseDate('${json['deadline']}'),
      boardId: int.tryParse('${json['board_id']}'),
      performer: json['performer'] == null ? null : User.fromJson(json['performer']),
      creator: json['creator'] == null ? null : User.fromJson(json['creator']),
      createdAt: Utils.parseDate('${json['created_at'] ?? ''}'),
      lastUpdatedAt: Utils.parseDate('${json['updated_at']}'),
      comments: json['comments'] == null ? null : (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
    );
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
    List<Comment>? comments,
  }) {
    return Task(
      pk: this.pk,
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
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.pk,
        'title': this.title,
        'description': this.description,
        'deadline': this.deadline?.toIso8601String(),
        'board_id': this.boardId,
        'status': (this.status ?? TaskStatus.values.first).toString().split('.').last,
        'creator_id': this.creator?.id,
        'performer_id': this.performer?.id,
      };

  bool didChanges(Task comparingTask) {
    if (this.title != comparingTask.title) return true;

    if (this.performer?.id != comparingTask.performer?.id) return true;

    if (this.creator?.id != comparingTask.creator?.id) return true;

    if (this.status != comparingTask.status) return true;

    if (this.deadline != comparingTask.deadline) return true;

    if (this.description != comparingTask.description) return true;

    return false;
  }
}
