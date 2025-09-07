import 'dart:developer';
import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({required this.success, required this.message, this.data});

  ApiResponse<T> copyWith({bool? success, String? message, T? data}) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic>? json, {
    T Function(Object?)? fromJsonT,
  }) {
    log('🔹 Raw API Response: $json'); // Always log the full response

    if (json == null) {
      return const ApiResponse(
        success: false,
        message: "No response",
        data: null,
      );
    }

    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';

    T? parsedData;
    try {
      if (fromJsonT != null && json.containsKey('data')) {
        parsedData = json['data'] != null ? fromJsonT(json['data']) : null;
      } else if (json.containsKey('data')) {
        parsedData = json['data'] as T?;
      }
    } catch (e) {
      log('❌ Error parsing data: $e');
      parsedData = null;
    }

    return ApiResponse<T>(success: success, message: message, data: parsedData);
  }

  Map<String, dynamic> toJson({Object? Function(T)? toJsonT}) {
    Object? encodedData;
    try {
      if (toJsonT != null && data != null) {
        encodedData = toJsonT(data as T);
      } else {
        encodedData = data;
      }
    } catch (e) {
      log('❌ Error encoding data: $e');
      encodedData = null;
    }

    final json = {'success': success, 'message': message, 'data': encodedData};
    log('🔹 API Response toJson: $json'); // Log when converting back to JSON
    return json;
  }

  @override
  List<Object?> get props => [success, message, data];
}
