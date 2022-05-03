import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:task_manager/core/api/api_response.dart';
import 'package:task_manager/core/application.dart';
import 'package:task_manager/core/constants/error_types.dart';
import 'package:task_manager/core/models/board.dart';
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
      return VerifySmsAuthResponse(token: json?['access_token']);
    } else
      return VerifySmsAuthResponse(error: await compute(parseError, response.bodyBytes));
  }

  static Future<VoiceAuthenticationResponse> authenticateByVoice(File file) async {
    final response = await ApiBase.multipartFormdata(
      endpoint: VoiceAuthenticationLoginEndPoint(),
      urlParams: {'{phone}': (await Application.getPhone() ?? '')},
      filesKey: 'voice',
      files: [file],
    );

    if (response.isSuccess)
      return VoiceAuthenticationResponse(successMessage: 'nice');
    else
      return VoiceAuthenticationResponse(error: 'Error');
  }

  static Future<bool> verifyCompanyCode(String code) async {
    final response = await ApiBase.request(
      endpoint: GetCompanyByCodeEndPoint(),
      urlParams: {'{code}': code},
    );

    print(response.statusCode);

    return response.isSuccess;
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
    final response = await ApiBase.request(endpoint: GetCompanyUsers());

    if (response.isSuccess) {
      return UsersResponse(users: await compute(parseUsers, response.bodyBytes));
    } else {
      return UsersResponse(error: await compute(parseError, response.bodyBytes));
    }
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
    if (value == null || value is! List || value.isEmpty) return null;
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
