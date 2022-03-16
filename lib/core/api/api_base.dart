import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:task_manager/core/api/api_endpoints.dart';
import 'package:task_manager/core/application.dart';
import 'package:connectivity/connectivity.dart';

import 'api_response.dart';

class ApiBase {
  static Future<bool> hasConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<IOClient> _getClient() async {
    HttpClient httpClient = HttpClient();
    httpClient.connectionTimeout = Duration(seconds: 15);
    httpClient.badCertificateCallback = ((
      X509Certificate cert,
      String host,
      int port,
    ) {
      return true;
    });

    return IOClient(httpClient);
  }

  static Future<Map<String, String>> getHeaders() async => {
        'Authorization': 'Token ${await Application.getToken() ?? ''}',
        'Content-Type': 'application/json',
      };

  static String urlWithParams(String url, Map<String, dynamic>? urlParams) {
    return url;
  }

  static Future<ApiResponse> request({
    required ApiEndpoint endpoint,
    Map<String, dynamic>? urlParams,
    Map<String, dynamic>? params,
    Duration? duration,
  }) async {
    if (!await hasConnection()) return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);

    final baseUrl = Application.getBaseUrl();
    final client = await _getClient();
    final headers = await getHeaders();

    http.Response response;

    switch (endpoint.method) {
      case RequestMethod.get:
        try {
          String url = urlWithParams(baseUrl + endpoint.url, urlParams);
          response = await client.get(Uri.parse(url), headers: headers).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        }

        break;
      case RequestMethod.post:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.post(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        }

        break;
      case RequestMethod.put:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.put(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        }
        break;
      case RequestMethod.delete:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.delete(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          return ApiResponse(body: null, bodyBytes: Uint8List(0), isSuccess: false, statusCode: -1);
        }
        break;
    }

    print('\n-----------------------');
    print('URL: ${endpoint.url}');
    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');
    print('-----------------------\n');

    return ApiResponse(
      body: response.body,
      bodyBytes: response.bodyBytes,
      isSuccess: response.statusCode == endpoint.statusCode,
      statusCode: response.statusCode,
    );
  }
}
