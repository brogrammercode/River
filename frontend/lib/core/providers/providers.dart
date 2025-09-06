import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/di/container.dart';
import 'package:frontend/core/dio/dio_client.dart';
import 'package:frontend/features/auth/data/data_source/auth_data_source.dart';
import 'package:frontend/features/auth/domain/repo/auth_repo.dart';
import 'package:frontend/features/auth/presentation/riverpod/auth_notifier.dart';
import 'package:frontend/features/auth/presentation/riverpod/auth_state.dart';
import 'package:frontend/features/items/data/data_source/item_data_source.dart';
import 'package:frontend/features/items/domain/repo/item_repo.dart';
import 'package:frontend/features/items/presentation/riverpod/item_notifier.dart';
import 'package:frontend/features/items/presentation/riverpod/item_state.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthDataSource(
    flutterSecureStorage: Injections.get<FlutterSecureStorage>(),
    dioClient: Injections.get<DioClient>(),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repo = ref.watch(authRepoProvider);
  return AuthNotifier(repo: repo);
});

final itemRepoProvider = Provider<ItemRepo>((ref) {
  return ItemDataSource(dioClient: Injections.get<DioClient>());
});

final itemNotifierProvider = StateNotifierProvider<ItemNotifier, ItemState>((
  ref,
) {
  final repo = ref.watch(itemRepoProvider);
  return ItemNotifier(repo: repo);
});
