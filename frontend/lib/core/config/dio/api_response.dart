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
    if (json == null) {
      return const ApiResponse(success: false, message: "No response");
    }
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson({Object? Function(T)? toJsonT}) {
    return {
      'success': success,
      'message': message,
      'data': toJsonT != null ? toJsonT(data as T) : data,
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}
