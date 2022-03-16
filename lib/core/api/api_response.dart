import 'dart:typed_data';

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
