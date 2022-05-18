import 'dart:typed_data';

import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/session.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';

class ApiResponse {
  final Uint8List bodyBytes;
  final String? body;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({
    required this.body,
    required this.bodyBytes,
    required this.isSuccess,
    required this.statusCode,
  });
}

class PhoneAuthResponse {
  final bool success;
  final String? error;

  PhoneAuthResponse({this.error, this.success = false});
}

class VerifySmsAuthResponse {
  final String? token;
  final String? error;
  final bool hasAccount;

  VerifySmsAuthResponse({this.token, this.error, required this.hasAccount});
}

class VoiceAuthenticationResponse {
  final String? error;
  final String? successMessage;

  VoiceAuthenticationResponse({this.error, this.successMessage});
}

class BoardsResponse {
  final String? error;
  final List<Board>? boards;

  BoardsResponse({this.error, this.boards});
}

class BooleanResponse {
  final bool? success;
  final String? error;

  BooleanResponse({this.success, this.error});
}

class UsersResponse {
  final List<User>? users;
  final String? error;

  UsersResponse({this.users, this.error});
}

class UserResponse {
  final User? user;
  final String? error;

  UserResponse({this.user, this.error});
}

class TaskResponse {
  final Task? task;
  final String? error;

  TaskResponse({this.task, this.error});
}

class TasksResponse {
  final List<Task>? tasks;
  final String? error;

  TasksResponse({this.tasks, this.error});
}

class SessionsResponse {
  final List<Session>? sessions;
  final String? error;

  SessionsResponse({this.sessions, this.error});
}
