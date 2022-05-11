import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/api/api_endpoints.dart';
import 'package:task_manager/core/application.dart';
import 'package:connectivity/connectivity.dart';
import 'package:task_manager/core/utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:easy_localization/easy_localization.dart';

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

  static Future<Map<String, String>> getHeaders() async => {
        'Authorization': 'Bearer ${await Application.getToken() ?? ''}',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      };

  static String urlWithParams(String url, Map<String, dynamic>? urlParams) {
    if (urlParams == null) return url;
    urlParams.forEach((key, value) => url = url.replaceAll(key, value));
    return url;
  }

  static Future<ApiResponse> request({
    required ApiEndpoint endpoint,
    Map<String, dynamic>? urlParams,
    Map<String, dynamic>? params,
    Duration? duration,
  }) async {
    if (!await hasConnection()) {
      return ApiResponse(
        body: null,
        bodyBytes: Uint8List.fromList(jsonEncode({'detail': 'no_internet_connection'.tr()}).codeUnits),
        isSuccess: false,
        statusCode: -1,
      );
    }

    final baseUrl = Application.getBaseUrl();
    final client = http.Client();
    final headers = await getHeaders();

    http.Response response;

    switch (endpoint.method) {
      case RequestMethod.get:
        try {
          String url = urlWithParams(baseUrl + endpoint.url, urlParams);
          response = await client.get(Uri.parse(url), headers: headers).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'timeout_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'socket_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        }

        break;
      case RequestMethod.post:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.post(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'timeout_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'socket_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        }

        break;
      case RequestMethod.put:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.put(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'timeout_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'socket_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        }
        break;
      case RequestMethod.delete:
        String url = urlWithParams(baseUrl + endpoint.url, urlParams);
        try {
          final body = jsonEncode(params);

          response = await client.delete(Uri.parse(url), headers: headers, body: body).timeout(duration ?? const Duration(seconds: 30));
        } on TimeoutException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'timeout_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        } on SocketException catch (_) {
          final bodyBytes = Uint8List.fromList(jsonEncode({'detail': 'socket_exception'.tr()}).codeUnits);
          return ApiResponse(body: null, bodyBytes: bodyBytes, isSuccess: false, statusCode: -1);
        }
        break;
    }

    print('\n-----------------------');
    print('URL: ${urlWithParams(baseUrl + endpoint.url, urlParams)}');
    print('METHOD: ${endpoint.method}');
    print('HEADERS: $headers');
    print('STATUS CODE: ${response.statusCode}');
    print('PARAMS: $params');
    print('URL PARAMS: $urlParams');
    print('BODY: ${response.body}');
    print('-----------------------\n');

    return ApiResponse(
      body: response.body,
      bodyBytes: response.bodyBytes,
      isSuccess: response.statusCode == endpoint.statusCode,
      statusCode: response.statusCode,
    );
  }

  static Future<ApiResponse> multipartFormdata({
    required ApiEndpoint endpoint,
    Map<String, String>? params,
    Map<String, String>? urlParams,
    Map<String, String>? inputHeaders,
    List<File>? files,
    bool encoded = true,
    String? filesKey,
  }) async {
    if (endpoint.method != RequestMethod.post) throw Exception(['\nOnly POST method allowed!\n']);

    final url = urlWithParams(Application.getBaseUrl() + endpoint.url, urlParams);

    http.MultipartRequest request = http.MultipartRequest(
      Utils.getRequestMethod(endpoint.method),
      Uri.parse(url),
    );

    request.headers.addAll(inputHeaders ?? {'Content-Type': 'multipart/form-data'});
    if (params != null && params.isNotEmpty) {
      request.fields.addAll(params);
    }
    if (files != null && files.isNotEmpty) {
      for (int i = 0; i < files.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            filesKey ?? 'files',
            files[i].path,
            contentType: MediaType('audio', 'mp4'),
          ),
        );
      }
    }

    final response = await http.Response.fromStream(await request.send());

    print('\n-----------------------');
    print('URL: $url');
    print('HEADERS: ${inputHeaders ?? await ApiBase.getHeaders()}');
    print('STATUS CODE: ${response.statusCode}');
    print('PARAMS: $params');
    print('URL PARAMS: $urlParams');
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
