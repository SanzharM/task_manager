import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:task_manager/core/api/api_response.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/error_types.dart';
import 'package:task_manager/core/models/board.dart';
import 'package:task_manager/core/models/session.dart';
import 'package:task_manager/core/models/task.dart';
import 'package:task_manager/core/models/user.dart';

import 'api_endpoints.dart';
import 'api_base.dart';

class ApiClient {
  static Future<PhoneAuthResponse> getAuth(String phone, String companyCode) async {
    final response = await ApiBase.request(
      endpoint: AuthEndpoint(),
      params: {'phone': phone, 'company_code': companyCode},
    );

    if (response.isSuccess)
      return PhoneAuthResponse(success: true);
    else
      return PhoneAuthResponse(error: await compute(parseError, response.bodyBytes));
  }

  static Future<VerifySmsAuthResponse> verifySmsCode(String phone, String code, String companyCode) async {
    final response = await ApiBase.request(
      endpoint: AuthVerifyEndpoint(),
      params: {'phone': phone, 'code': code, 'company_code': companyCode},
    );

    if (response.isSuccess) {
      await Application.setPhone(phone);
      final Map<String, dynamic>? json = await compute(parseVerifySmsAuth, response.bodyBytes);
      return VerifySmsAuthResponse(token: json?['access_token'], hasAccount: json?['is_exist'] ?? true);
    } else
      return VerifySmsAuthResponse(error: await compute(parseError, response.bodyBytes), hasAccount: false);
  }

  static Future<VoiceAuthenticationResponse> authenticateByVoice(File file) async {
    final _wrongAttempts = await Application.getWrongVoiceAttempts();
    if (_wrongAttempts > 3) {
      return VoiceAuthenticationResponse(error: 'wrong_attempts_limited');
    }
    final response = await ApiBase.multipartFormdata(
      endpoint: VoiceAuthenticationLoginEndPoint(),
      urlParams: {'{phone}': (await Application.getPhone() ?? '')},
      filesKey: 'voice',
      files: [file],
    );

    if (response.isSuccess) {
      await Application.setWrongVoiceAttempts(0);
      return VoiceAuthenticationResponse(successMessage: 'Voice authentication proceeded');
    } else {
      await Application.setWrongVoiceAttempts(_wrongAttempts + 1);
      return VoiceAuthenticationResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<VoiceAuthenticationResponse> registerVoice(File file) async {
    final response = await ApiBase.multipartFormdata(
      endpoint: VoiceAuthenticationRegistrationEndPoint(),
      urlParams: {'{phone}': (await Application.getPhone() ?? '')},
      filesKey: 'voice',
      files: [file],
    );

    if (response.isSuccess)
      return VoiceAuthenticationResponse(successMessage: 'Voice successfully recorded and saved');
    else
      return VoiceAuthenticationResponse(error: await compute(parseError, response.bodyBytes));
  }

  static Future<BooleanResponse> verifyCompanyCode(String code) async {
    final response = await ApiBase.request(
      endpoint: GetCompanyByCodeEndPoint(),
      urlParams: {'{code}': code},
    );

    return BooleanResponse(success: response.isSuccess, error: await compute(parseError, response.bodyBytes));
  }

  static Future<BoardsResponse> getBoards() async {
    final response = await ApiBase.request(endpoint: GetBoardsEndpoint());

    if (response.isSuccess) {
      return BoardsResponse(boards: await compute(parseBoards, response.bodyBytes));
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return BoardsResponse(error: ErrorType.tokenExpired);
    } else {
      return BoardsResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> createBoard({required String name, String? description}) async {
    final response = await ApiBase.request(
      endpoint: CreateBoardEndpoint(),
      params: {'name': name, 'description': description},
    );

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return BooleanResponse(success: false, error: 'Token expired');
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> createTask(Task task) async {
    final response = await ApiBase.request(
      endpoint: CreateTaskEndpoint(),
      params: task.toJson(),
    );

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<UsersResponse> getCompanyUsers() async {
    final response = await ApiBase.request(endpoint: GetCompanyUsersEndpoint());

    if (response.isSuccess) {
      return UsersResponse(users: await compute(parseUsers, response.bodyBytes));
    } else {
      return UsersResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<TaskResponse> getTask(int taskId) async {
    final response = await ApiBase.request(
      endpoint: GetTasksEndpoint(),
      params: {'task_id': taskId},
    );

    if (response.isSuccess) {
      return TaskResponse(task: await compute(parseTask, response.bodyBytes));
    } else {
      return TaskResponse(error: await parseError(response.bodyBytes));
    }
  }

  static Future<TasksResponse> getTasks(int boardId) async {
    final response = await ApiBase.request(endpoint: GetTasksEndpoint());

    if (response.isSuccess) {
      return TasksResponse(tasks: await compute(parseTasks, response.bodyBytes));
    } else {
      return TasksResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> editBoard(Board board) async {
    final response = await ApiBase.request(
      endpoint: EditBoardEndpoint(),
      params: board.toJson(),
    );

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> deleteBoard(Board board) async {
    final response = await ApiBase.request(
      endpoint: DeleteBoardEndpoint(),
      params: {'board_id': board.pk},
    );

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<SessionsResponse> getSessions() async {
    final response = await ApiBase.request(endpoint: GetSessionsEndpoint());

    if (response.isSuccess) {
      return SessionsResponse(sessions: await compute(parseSessions, response.bodyBytes));
    } else {
      return SessionsResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> setSession(LocationData data) async {
    final response = await ApiBase.request(
      endpoint: SetSessionEndpoint(),
      params: {'latitude': data.latitude, 'longitude': data.longitude},
    );

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else {
      return BooleanResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<UserResponse> getProfileData() async {
    final response = await ApiBase.request(endpoint: GetProfileEndpoint());

    if (response.isSuccess) {
      return UserResponse(user: await compute(parseUser, response.bodyBytes));
    } else {
      return UserResponse(error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> editProfile(User user) async {
    final response = await ApiBase.request(endpoint: EditProfileEndpoint(), params: user.toJson());

    if (response.isSuccess) {
      return BooleanResponse(success: true);
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> editTask(Task task) async {
    final response = await ApiBase.request(
      endpoint: EditTaskEndpoint(),
      params: task.toJson(),
    );

    return BooleanResponse(
      success: response.isSuccess,
      error: await compute(parseError, response.bodyBytes),
    );
  }

  static Future<BooleanResponse> checkRecordedVoice() async {
    final response = await ApiBase.request(
      endpoint: CheckHasRecordedVoiceEndPoint(),
      urlParams: {'{phone}': await Application.getPhone()},
    );

    if (response.isSuccess) {
      return BooleanResponse(success: response.body == 'true');
    } else {
      return BooleanResponse(success: false, error: await compute(parseError, response.bodyBytes));
    }
  }

  static Future<BooleanResponse> deleteVoice() async {
    final response = await ApiBase.request(endpoint: DeleteVoiceEndPoint());

    return BooleanResponse(success: response.isSuccess, error: await compute(parseError, response.bodyBytes));
  }
}

Future<String> parseError(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes)) as Map<String, dynamic>?;
    if (json?['detail'] != null) {
      return json!['detail'].toString();
    }
    return convert.utf8.decode(bodyBytes);
  } catch (e) {
    return convert.utf8.decode(bodyBytes);
  }
}

Future<Map<String, dynamic>?> parseVerifySmsAuth(Uint8List bodyBytes) async {
  try {
    return convert.json.decode(convert.utf8.decode(bodyBytes));
  } catch (e) {
    return null;
  }
}

Future<List<Board>?> parseBoards(Uint8List bodyBytes) async {
  try {
    final value = convert.json.decode(convert.utf8.decode(bodyBytes));
    if (value == null || value is! List) return null;
    return value.map((e) => Board.fromJson(e)).toList();
  } catch (e) {
    return null;
  }
}

Future<List<User>?> parseUsers(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes));
    if (json == null || json is! List) return null;
    return json.map((e) => User.fromJson(e)).toList();
  } catch (e) {
    return null;
  }
}

Future<User?> parseUser(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes));
    if (json == null) return null;
    return User.fromJson(json);
  } catch (e) {
    return null;
  }
}

Future<Task?> parseTask(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes));
    return Task.fromJson(json);
  } catch (e) {
    return null;
  }
}

Future<List<Task>?> parseTasks(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes));
    if (json == null || json is! List) return null;
    return json.map((e) => Task.fromJson(e)).toList();
  } catch (e) {
    return null;
  }
}

Future<List<Session>?> parseSessions(Uint8List bodyBytes) async {
  try {
    final json = convert.json.decode(convert.utf8.decode(bodyBytes));
    if (json == null || json is! List) return null;
    return json.map((e) => Session.fromJson(e)).toList();
  } catch (e) {
    return null;
  }
}
