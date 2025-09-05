import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/features/auth/domain/repo/auth_repo.dart';
import 'package:frontend/features/auth/presentation/riverpod/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepo _repo;

  AuthNotifier({required AuthRepo repo})
    : _repo = repo,
      super(const AuthState()) {
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      state = state.copyWith(authInitStatus: CommonStatus.loading);
      final token = await _repo.getToken();
      if (token.isNotEmpty) {
        final user = await _repo.getMe();
        state = state.copyWith(
          token: token,
          user: user,
          authInitStatus: CommonStatus.success,
        );
      } else {
        state = state.copyWith(authInitStatus: CommonStatus.success);
      }
    } catch (e) {
      log("INIT_AUTH_ERROR: $e");
      state = state.copyWith(
        authInitStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = state.copyWith(loginStatus: CommonStatus.loading);
      final user = await _repo.login(email: email, password: password);
      final token = await _repo.getToken();
      state = state.copyWith(
        user: user,
        token: token,
        loginStatus: CommonStatus.success,
      );
    } catch (e) {
      log("LOGIN_ERROR: $e");
      state = state.copyWith(
        loginStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      state = state.copyWith(registerStatus: CommonStatus.loading);
      final user = await _repo.register(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      final token = await _repo.getToken();
      state = state.copyWith(
        user: user,
        token: token,
        registerStatus: CommonStatus.success,
      );
    } catch (e) {
      log("REGISTER_ERROR: $e");
      state = state.copyWith(
        registerStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(logoutStatus: CommonStatus.loading);
      await _repo.logout();
      await _repo.clearToken();
      state = const AuthState(logoutStatus: CommonStatus.success);
    } catch (e) {
      log("LOGOUT_ERROR: $e");
      state = state.copyWith(
        logoutStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> getMe() async {
    try {
      state = state.copyWith(getMeStatus: CommonStatus.loading);
      final user = await _repo.getMe();
      state = state.copyWith(user: user, getMeStatus: CommonStatus.success);
    } catch (e) {
      log("GET_ME_ERROR: $e");
      state = state.copyWith(
        getMeStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> getToken() async {
    try {
      state = state.copyWith(getTokenStatus: CommonStatus.loading);
      final token = await _repo.getToken();
      state = state.copyWith(
        token: token,
        getTokenStatus: CommonStatus.success,
      );
    } catch (e) {
      log("GET_TOKEN_ERROR: $e");
      state = state.copyWith(
        getTokenStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> saveToken({required String token}) async {
    try {
      state = state.copyWith(saveTokenStatus: CommonStatus.loading);
      await _repo.saveToken(token: token);
      state = state.copyWith(
        token: token,
        saveTokenStatus: CommonStatus.success,
      );
    } catch (e) {
      log("SAVE_TOKEN_ERROR: $e");
      state = state.copyWith(
        saveTokenStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }

  Future<void> clearToken() async {
    try {
      state = state.copyWith(clearTokenStatus: CommonStatus.loading);
      await _repo.clearToken();
      state = state.copyWith(token: "", clearTokenStatus: CommonStatus.success);
    } catch (e) {
      log("CLEAR_TOKEN_ERROR: $e");
      state = state.copyWith(
        clearTokenStatus: CommonStatus.failure,
        error: CommonError(consoleMessage: e.toString()),
      );
    }
  }
}
