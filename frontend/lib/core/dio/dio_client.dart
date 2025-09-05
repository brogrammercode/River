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
          if (_shouldRetry(error) &&
              error.requestOptions.extra['retryCount'] == null) {
            error.requestOptions.extra['retryCount'] = 1;
            log('🔄 Retrying request: ${error.requestOptions.uri}');
            try {
              final response = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              handler.resolve(response);
            } catch (_) {
              handler.next(error);
            }
          } else {
            handler.next(error);
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
