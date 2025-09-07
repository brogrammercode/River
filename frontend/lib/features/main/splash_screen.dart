import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/di/container.dart';
import 'package:frontend/core/providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final FlutterSecureStorage _storage = Injections.get<FlutterSecureStorage>();
  static const String userIdKey = "user_id";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    try {
      await authNotifier.getToken();
      final token = ref.read(authNotifierProvider).token;
      if (token.isEmpty) {
        _navigateTo("/login");
        return;
      }

      await authNotifier.getMe();
      final user = ref.read(authNotifierProvider).user;

      if (user != null) {
        final savedUserId = await _storage.read(key: userIdKey);
        if (savedUserId == null || savedUserId.isEmpty) {
          await _storage.write(key: userIdKey, value: user.id);
          log("UID saved locally: ${user.id}");
        }
        _navigateTo("/items");
      } else {
        _navigateTo("/login");
      }
    } catch (e) {
      log("SPLASH_AUTH_ERROR: $e");
      _navigateTo("/login");
    }
  }

  void _navigateTo(String route) {
    if (!mounted) return;
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
