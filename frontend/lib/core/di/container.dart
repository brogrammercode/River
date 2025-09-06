import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/dio/dio_client.dart';
import 'package:frontend/features/auth/data/data_source/auth_data_source.dart';
import 'package:frontend/features/auth/domain/repo/auth_repo.dart';
import 'package:frontend/features/items/data/data_source/item_data_source.dart';
import 'package:frontend/features/items/domain/repo/item_repo.dart';
import 'package:get_it/get_it.dart';

class Injections {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {
    // Core
    _getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
    _getIt.registerLazySingleton<Dio>(() => Dio());
    _getIt.registerLazySingleton<DioClient>(
      () => DioClient(_getIt(), _getIt()),
    );

    // Auth Feature
    _getIt.registerLazySingleton<AuthRepo>(
      () => AuthDataSource(flutterSecureStorage: _getIt(), dioClient: _getIt()),
    );

    // Auth Feature
    _getIt.registerLazySingleton<ItemRepo>(
      () => ItemDataSource(dioClient: _getIt()),
    );
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
