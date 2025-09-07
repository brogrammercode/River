import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/dio/api_response.dart';
import 'package:frontend/core/dio/dio_client.dart';
import 'package:frontend/core/error/exception.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/features/auth/domain/repo/auth_repo.dart';

class AuthDataSource implements AuthRepo {
  final FlutterSecureStorage _flutterSecureStorage;
  final DioClient _dioClient;
  static const String tokenKey = "token_key";
  static const String userIdKey = "user_id";

  AuthDataSource({
    required FlutterSecureStorage flutterSecureStorage,
    required DioClient dioClient,
  }) : _flutterSecureStorage = flutterSecureStorage,
       _dioClient = dioClient;

  @override
  Future<void> clearToken() async {
    try {
      await _flutterSecureStorage.delete(key: tokenKey);
    } catch (e) {
      throw CacheException("CLEAR_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<void> saveToken({required String token}) async {
    try {
      await _flutterSecureStorage.write(key: tokenKey, value: token);
    } catch (e) {
      throw CacheException("SAVE_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<String> getToken() async {
    try {
      final token = await _flutterSecureStorage.read(key: tokenKey);
      return token ?? "";
    } catch (e) {
      throw CacheException("GET_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<void> clearUID() async {
    try {
      await _flutterSecureStorage.delete(key: userIdKey);
    } catch (e) {
      throw CacheException("CLEAR_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<void> saveUID({required String uid}) async {
    try {
      await _flutterSecureStorage.write(key: userIdKey, value: uid);
    } catch (e) {
      throw CacheException("SAVE_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<String> getUID() async {
    try {
      final token = await _flutterSecureStorage.read(key: userIdKey);
      return token ?? "";
    } catch (e) {
      throw CacheException("GET_TOKEN_ERROR: $e");
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) {
          final data = json as Map<String, dynamic>;
          return UserModel.fromJson(data['user'] as Map<String, dynamic>);
        },
      );

      if (apiResponse.success && apiResponse.data != null) {
        final user = apiResponse.data as UserModel;
        await saveUID(uid: user.id ?? "");
        final responseData = response.data as Map<String, dynamic>;
        final token = responseData['data']?['token'] as String?;

        if (token != null && token.isNotEmpty) {
          await saveToken(token: token);
        } else {
          throw ServerException("LOGIN_ERROR: Token not received from server");
        }

        return user;
      } else {
        throw ServerException("LOGIN_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException || e is CacheException) rethrow;
      throw ServerException("LOGIN_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dioClient.dio.post("/auth/logout");

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) => null,
      );

      if (!apiResponse.success) {
        throw ServerException("LOGOUT_ERROR: ${apiResponse.message}");
      }

      await clearToken();
      await clearUID();
    } on DioException catch (e) {
      await clearToken();
      throw _handleDioError(e);
    } catch (e) {
      await clearToken();
      if (e is ServerException || e is CacheException) rethrow;
      throw ServerException("LOGOUT_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        "/auth/register",
        data: {
          "email": email,
          "password": password,
          "name": name,
          "role": role,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) {
          final data = json as Map<String, dynamic>;
          return UserModel.fromJson(data['user'] as Map<String, dynamic>);
        },
      );

      if (apiResponse.success && apiResponse.data != null) {
        final user = apiResponse.data as UserModel;
        await saveUID(uid: user.id ?? "");
        final responseData = response.data as Map<String, dynamic>;
        final token = responseData['data']?['token'] as String?;

        if (token != null && token.isNotEmpty) {
          await saveToken(token: token);
        } else {
          throw ServerException(
            "REGISTER_ERROR: Token not received from server",
          );
        }

        return user;
      } else {
        throw ServerException("REGISTER_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException || e is CacheException) rethrow;
      throw ServerException("REGISTER_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dioClient.dio.get("/auth/me");

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as UserModel;
      } else {
        throw ServerException("GET_ME_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stack) {
      if (e is ServerException) rethrow;
      log("GET_ME raw error: $e");
      log("STACKTRACE: $stack");
      throw ServerException("GET_ME_ERROR: Unexpected error occurred");
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        String message = 'Server error';

        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? responseData['error'] ?? message;
        }

        switch (statusCode) {
          case 400:
            return ServerException('Bad Request: $message');
          case 401:
            return ServerException('Unauthorized: $message');
          case 403:
            return ServerException('Forbidden: $message');
          case 404:
            return ServerException('Not Found: $message');
          case 500:
            return ServerException('Internal Server Error: $message');
          default:
            return ServerException('HTTP $statusCode: $message');
        }
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      case DioExceptionType.badCertificate:
        return NetworkException('Certificate verification failed');
      case DioExceptionType.connectionError:
        return NetworkException(
          'Connection failed. Please check your internet connection.',
        );
      case DioExceptionType.unknown:
        return NetworkException(
          'Network error: ${e.message ?? "Unknown error occurred"}',
        );
    }
  }
}
