import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import 'package:sample/app/service/db/db.dart';

class ApiClient {
  ApiClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final Dio _dio;

  String? _bearerToken;
  String? _cookies;
  bool debugLoggingEnabled = true;

  void setBearerToken(String? token) {
    _bearerToken = token;
  }

  Future<void> initializeToken() async {
    final authStorage = AuthStorageService();
    final token = await authStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _bearerToken = token;
    }
    final savedCookies = await authStorage.getCookie();
    if (savedCookies != null && savedCookies.isNotEmpty) {
      _cookies = savedCookies;
      _dio.options.headers['Cookie'] = _cookies;
    }
  }

  void _setCookiesFromResponse(Response response) {
    final cookies = response.headers['set-cookie'];
    if (cookies != null && cookies.isNotEmpty) {
      final cookieMap = <String, String>{};
      for (var cookie in cookies) {
        final parts = cookie.split(';')[0].split('=');
        if (parts.length == 2) {
          cookieMap[parts[0].trim()] = parts[1].trim();
        }
      }
      final cookieString =
          cookieMap.entries.map((e) => '${e.key}=${e.value}').join('; ');
      _cookies = cookieString;
      _dio.options.headers['Cookie'] = cookieString;
      final authStorage = AuthStorageService();
      authStorage.saveCookie(cookieString);
      if (kDebugMode && debugLoggingEnabled) {
        debugPrint('🔵 Set cookies from response: $cookieString');
      }
    }
  }

  void clearCookies() {
    _cookies = null;
    _dio.options.headers.remove('Cookie');
    final authStorage = AuthStorageService();
    authStorage.saveCookie('');
  }

  Options _withAuth([Options? options]) {
    final Map<String, dynamic> headers = {
      ...?options?.headers,
      if (_bearerToken != null && _bearerToken!.isNotEmpty)
        'Authorization': 'Bearer $_bearerToken',
      if (_cookies != null && _cookies!.isNotEmpty) 'Cookie': _cookies!,
    };
    return (options ?? Options()).copyWith(headers: headers);
  }

  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool authenticated = false,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: authenticated ? _withAuth(options) : options,
      );
      final statusCode = response.statusCode ?? 0;
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid response format: expected Map<String, dynamic>',
        );
      }

      final (isSuccess, extractedMessage) = _extractResponseStatus(data);
      final bool isActuallySuccess = statusCode == 200 && isSuccess;

      _setCookiesFromResponse(response);

      if (debugLoggingEnabled) {
        _log(
          method: 'GET',
          path: path,
          statusCode: statusCode,
          query: queryParameters,
          data: data,
          isError: !isActuallySuccess,
        );
      }

      return ApiResponse(
        status: isActuallySuccess,
        statusCode: statusCode,
        data: data,
        message: extractedMessage,
      );
    } on DioException catch (e) {
      return _handleDioException(
        e,
        method: 'GET',
        path: path,
        queryParameters: queryParameters,
      );
    } on FormatException catch (e) {
      return _handleFormatException(
        e,
        method: 'GET',
        path: path,
        queryParameters: queryParameters,
      );
    } catch (e) {
      return _handleGenericException(
        e,
        method: 'GET',
        path: path,
        queryParameters: queryParameters,
      );
    }
  }

  Future<ApiResponse> postMultipart(
    String path, {
    formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool authenticated = false,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: authenticated ? _withAuth(options) : options,
      );

      final statusCode = response.statusCode ?? 0;
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid response format: expected Map<String, dynamic>',
        );
      }

      final (isSuccess, extractedMessage) = _extractResponseStatus(body);
      final bool isActuallySuccess = statusCode == 200 && isSuccess;

      _setCookiesFromResponse(response);

      if (debugLoggingEnabled) {
        _log(
          method: 'POST (Multipart)',
          path: path,
          statusCode: statusCode,
          query: queryParameters,
          requestBody: 'FormData',
          data: body,
          isError: !isActuallySuccess,
        );
      }

      return ApiResponse(
        status: isActuallySuccess,
        statusCode: statusCode,
        data: body,
        message: extractedMessage,
      );
    } on DioException catch (e) {
      return _handleDioException(
        e,
        method: 'POST (Multipart)',
        path: path,
        queryParameters: queryParameters,
        requestBody: 'FormData',
      );
    } on FormatException catch (e) {
      return _handleFormatException(
        e,
        method: 'POST (Multipart)',
        path: path,
        queryParameters: queryParameters,
        requestBody: 'FormData',
      );
    } catch (e) {
      return _handleGenericException(
        e,
        method: 'POST (Multipart)',
        path: path,
        queryParameters: queryParameters,
        requestBody: 'FormData',
      );
    }
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool authenticated = false,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: authenticated ? _withAuth(options) : options,
      );
      final statusCode = response.statusCode ?? 0;
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const FormatException(
          'Invalid response format: expected Map<String, dynamic>',
        );
      }

      final (isSuccess, extractedMessage) = _extractResponseStatus(body);
      final bool isActuallySuccess = statusCode == 200 && isSuccess;

      _setCookiesFromResponse(response);

      if (debugLoggingEnabled) {
        _log(
          method: 'POST',
          path: path,
          statusCode: statusCode,
          query: queryParameters,
          requestBody: data,
          data: body,
          isError: !isActuallySuccess,
        );
      }

      return ApiResponse(
        status: isActuallySuccess,
        statusCode: statusCode,
        data: body,
        message: extractedMessage,
      );
    } on DioException catch (e) {
      return _handleDioException(
        e,
        method: 'POST',
        path: path,
        queryParameters: queryParameters,
        requestBody: data,
      );
    } on FormatException catch (e) {
      return _handleFormatException(
        e,
        method: 'POST',
        path: path,
        queryParameters: queryParameters,
        requestBody: data,
      );
    } catch (e) {
      return _handleGenericException(
        e,
        method: 'POST',
        path: path,
        queryParameters: queryParameters,
        requestBody: data,
      );
    }
  }

  (bool, String) _extractResponseStatus(Map<String, dynamic> data) {
    if (!data.containsKey('message')) {
      return (true, '');
    }

    final messageValue = data['message'];

    if (messageValue is String) {
      return (true, messageValue);
    }

    if (messageValue is Map<String, dynamic>) {
      final messageObj = messageValue;

      final status = messageObj['status'] as bool?;
      if (status == false) {
        final errorMessage = messageObj['message'] as String? ??
            messageObj['error_code'] as String? ??
            'Something went wrong';
        return (false, errorMessage);
      }

      final code = messageObj['code'];
      if (code is int && code >= 400) {
        final errorMessage = messageObj['message'] as String? ??
            messageObj['error_code'] as String? ??
            'Something went wrong';
        return (false, errorMessage);
      }

      // Handle nested message structure: message.message.data
      // Check if message is another Map (nested structure)
      final innerMessage = messageObj['message'];
      if (innerMessage is Map<String, dynamic>) {
        // This is a nested structure, extract from inner message
        final innerStatus = innerMessage['status'] as String?;
        if (innerStatus == 'fail' ||
            innerStatus == 'error' ||
            innerStatus == 'failed') {
          final errorMessage = innerMessage['message'] as String? ??
              innerMessage['error_code'] as String? ??
              'Something went wrong';
          return (false, errorMessage);
        }

        final innerCode = innerMessage['code'];
        if (innerCode is int && innerCode >= 400) {
          final errorMessage = innerMessage['message'] as String? ??
              innerMessage['error_code'] as String? ??
              'Something went wrong';
          return (false, errorMessage);
        }

        final successMessage = innerMessage['message'] as String? ?? '';
        return (true, successMessage);
      }

      // Non-nested structure: message is a String
      final successMessage = messageObj['message'] is String
          ? messageObj['message'] as String
          : '';
      return (true, successMessage);
    }

    return (true, messageValue.toString());
  }

  ApiResponse _handleDioException(
    DioException e, {
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic requestBody,
  }) {
    final statusCode = e.response?.statusCode ?? 0;
    final errDataRaw = e.response?.data;

    Map<String, dynamic> errData;
    if (errDataRaw is Map<String, dynamic>) {
      errData = errDataRaw;
    } else if (errDataRaw is String) {
      try {
        errData = jsonDecode(errDataRaw) as Map<String, dynamic>;
      } catch (_) {
        errData = {
          'error': errDataRaw.toString(),
          'message': 'Something went wrong',
        };
      }
    } else {
      errData = {
        'error': errDataRaw?.toString() ?? 'Unknown error',
        'message': 'Something went wrong',
      };
    }

    String errorMessage = 'Something went wrong';
    if (errData.containsKey('message')) {
      final messageValue = errData['message'];
      if (messageValue is String) {
        errorMessage = messageValue;
      } else if (messageValue is Map<String, dynamic>) {
        errorMessage = messageValue['message'] as String? ??
            messageValue['error_code'] as String? ??
            'Something went wrong';
      }
    } else if (errData.containsKey('error_code')) {
      errorMessage = errData['error_code'].toString();
    }

    if (debugLoggingEnabled) {
      _log(
        method: method,
        path: path,
        statusCode: statusCode,
        query: queryParameters,
        requestBody: requestBody,
        data: errData,
        isError: true,
      );
    }
    return ApiResponse(
      status: false,
      statusCode: statusCode,
      data: errData,
      message: errorMessage,
    );
  }

  ApiResponse _handleFormatException(
    FormatException e, {
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic requestBody,
  }) {
    if (debugLoggingEnabled) {
      _log(
        method: method,
        path: path,
        statusCode: 0,
        query: queryParameters,
        requestBody: requestBody,
        data: {'error': e.message},
        isError: true,
      );
    }
    return ApiResponse(
      status: false,
      statusCode: 0,
      data: {'error': e.message},
      message: e.message,
    );
  }

  ApiResponse _handleGenericException(
    dynamic e, {
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic requestBody,
  }) {
    if (debugLoggingEnabled) {
      _log(
        method: method,
        path: path,
        statusCode: 0,
        query: queryParameters,
        requestBody: requestBody,
        data: {'error': e.toString()},
        isError: true,
      );
    }
    return ApiResponse(
      status: false,
      statusCode: 0,
      data: {'error': e.toString()},
      message: 'An unexpected error occurred',
    );
  }

  void _log({
    required String method,
    required String path,
    required int statusCode,
    Map<String, dynamic>? query,
    dynamic requestBody,
    required Map<String, dynamic> data,
    bool isError = false,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('=== API ${isError ? 'ERROR ' : ''}LOG ===');
    buffer.writeln('Method    : $method');
    buffer.writeln('URL       : ${ApiConstants.baseUrl}$path');
    if (query != null && query.isNotEmpty) {
      buffer.writeln(
        'Query     : ${const JsonEncoder.withIndent('  ').convert(query)}',
      );
    }
    if (requestBody != null) {
      buffer.writeln(
        'Request   : ${const JsonEncoder.withIndent('  ').convert(requestBody)}',
      );
    }
    buffer.writeln('Status    : $statusCode');
    buffer.writeln(
      'Response  : ${const JsonEncoder.withIndent('  ').convert(data)}',
    );
    buffer.writeln('==========================');

    final logMessage = buffer.toString();
    debugPrint('🔵 $logMessage', wrapWidth: 1024);
  }
}
