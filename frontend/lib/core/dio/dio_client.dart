import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  static const String baseUrl = "https://river-production.up.railway.app/api";
  static const String tokenKey = "token_key";

  DioClient(Dio dio, this._secureStorage) {
    _dio = dio;
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      validateStatus: (status) => status != null && status < 500,
      followRedirects: false,
      maxRedirects: 0,
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _secureStorage.read(key: tokenKey);
            log("TOKEN IN INTERCEPTOR: $token");
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            options.headers['X-Request-ID'] = DateTime.now()
                .millisecondsSinceEpoch
                .toString();
            log('🚀 REQUEST: ${options.method} ${options.uri}');
            if (options.data != null) log('📦 DATA: ${options.data}');
          } catch (e) {
            log('❌ Error setting up request: $e');
          }
          log('FINAL HEADERS: ${options.headers}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          log(
            '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
          );
          handler.next(response);
        },
        onError: (error, handler) async {
          log(
            '❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.uri}',
          );
          log('❌ ERROR MESSAGE: ${error.message}');
          if (error.response?.statusCode == 401) {
            await _handleTokenExpiration();
          }
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            log('⏰ Network timeout occurred');
          }
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final options = error.requestOptions;
          int retries = options.extra['retryCount'] ?? 0;

          if (_shouldRetry(error) && retries < 2) {
            // limit to 2 retries
            options.extra['retryCount'] = retries + 1;
            log('🔄 Retrying request (${retries + 1}/2): ${options.uri}');

            try {
              final response = await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );
              return handler.resolve(response);
            } catch (_) {
              return handler.next(error);
            }
          } else {
            return handler.next(error);
          }
        },
      ),
    );

  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  Future<void> _handleTokenExpiration() async {
    try {
      await _secureStorage.delete(key: tokenKey);
      log('🗑️ Token cleared due to expiration');
    } catch (e) {
      log('❌ Error clearing expired token: $e');
    }
  }

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  void setCustomHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  void clearHeaders() {
    _dio.options.headers.clear();
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }
}
