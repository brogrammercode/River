import 'package:dio/dio.dart';
import 'package:frontend/core/dio/api_response.dart';
import 'package:frontend/core/dio/dio_client.dart';
import 'package:frontend/core/error/exception.dart';
import 'package:frontend/features/items/data/models/item_model.dart';
import 'package:frontend/features/items/domain/repo/item_repo.dart';

class ItemDataSource implements ItemRepo {
  final DioClient _dioClient;

  ItemDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<ItemModel>> getUserItems() async {
    try {
      final response = await _dioClient.dio.get("/item");

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (data) {
          final dataMap = data as Map<String, dynamic>;
          final itemsList = dataMap['items'] as List<dynamic>?;
          return itemsList?.map((e) => ItemModel.fromJson(e)).toList() ?? [];
        },
      );


      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ItemModel>;
      } else {
        throw ServerException("GET_USER_ITEMS_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("GET_USER_ITEMS_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<List<ItemModel>> getAssignedItems() async {
    try {
      final response = await _dioClient.dio.get("/item/assigned");

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) {
          final list = json as List<dynamic>;
          return list.map((e) => ItemModel.fromJson(e)).toList();
        },
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data as List<ItemModel>;
      } else {
        throw ServerException(
          "GET_ASSIGNED_ITEMS_ERROR: ${apiResponse.message}",
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        "GET_ASSIGNED_ITEMS_ERROR: Unexpected error occurred",
      );
    }
  }

  @override
  Future<bool> createItem({required ItemModel item}) async {
    try {
      final response = await _dioClient.dio.post("/item", data: item.toJson());

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) => null,
      );

      if (apiResponse.success) {
        return true;
      } else {
        throw ServerException("CREATE_ITEM_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("CREATE_ITEM_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<bool> updateItem({
    required String itemID,
    required ItemModel updatedItem,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        "/item/$itemID",
        data: updatedItem.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) => null,
      );

      if (apiResponse.success) {
        return true;
      } else {
        throw ServerException("UPDATE_ITEM_ERROR: ${apiResponse.message}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException("UPDATE_ITEM_ERROR: Unexpected error occurred");
    }
  }

  @override
  Future<bool> changeAssignmentToOtherReceiver({required String itemID}) async {
    try {
      final response = await _dioClient.dio.patch("/item/$itemID/reassign");

      final apiResponse = ApiResponse.fromJson(
        response.data,
        fromJsonT: (json) => null,
      );

      if (apiResponse.success) {
        return true;
      } else {
        throw ServerException(
          "CHANGE_ASSIGNMENT_ERROR: ${apiResponse.message}",
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        "CHANGE_ASSIGNMENT_ERROR: Unexpected error occurred",
      );
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
