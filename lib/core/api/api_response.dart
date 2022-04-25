import 'dart:typed_data';

import 'package:task_manager/core/models/board.dart';

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

  VerifySmsAuthResponse({this.token, this.error});
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
