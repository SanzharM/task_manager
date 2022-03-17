import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:task_manager/core/api/api_response.dart';

import 'api_endpoints.dart';
import 'api_base.dart';

class ApiClient {
  static Future<PhoneAuthResponse> getAuth(String phone) async {
    print(phone);
    final response = await ApiBase.request(
      endpoint: AuthEndpoint(),
      params: {'phone': phone},
    );

    if (response.isSuccess)
      return PhoneAuthResponse(success: true);
    else
      return PhoneAuthResponse(error: await compute(parseError, response.bodyBytes));
  }

  static Future<VerifySmsAuthResponse> verifySmsCode(String phone, String code) async {
    final response = await ApiBase.request(
      endpoint: AuthVerifyEndpoint(),
      params: {'phone': phone, 'code': code},
    );

    if (response.isSuccess) {
      final Map<String, dynamic>? json = await compute(parseVerifySmsAuth, response.bodyBytes);
      return VerifySmsAuthResponse(token: json?['access_token']);
    } else
      return VerifySmsAuthResponse(error: await compute(parseError, response.bodyBytes));
  }
}

Future<String> parseError(Uint8List bodyBytes) async {
  try {
    return json.decode(utf8.decode(bodyBytes));
  } catch (e) {
    return utf8.decode(bodyBytes);
  }
}

Future<Map<String, dynamic>?> parseVerifySmsAuth(Uint8List bodyBytes) async {
  try {
    var a = json.decode(utf8.decode(bodyBytes));
    print(a);
    return a;
  } catch (e) {}
}
