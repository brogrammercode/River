import 'package:frontend/features/auth/data/models/user_model.dart';

abstract interface class AuthRepo {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });
  Future<void> logout();
  Future<UserModel> getMe();
  Future<String> getToken();
  Future<void> saveToken({required String token});
  Future<void> clearToken();
  Future<String> getUID();
  Future<void> saveUID({required String uid});
  Future<void> clearUID();
}
