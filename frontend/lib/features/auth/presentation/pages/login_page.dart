import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/core/error/common_error.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authNotifierProvider.notifier);

    try {
      await notifier.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = ref.read(authNotifierProvider).user;
      log(
        "Login success: UserID=${user?.id}, Name=${user?.name}, Email=${user?.email}",
      );
    } catch (e) {
      log("Login error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.loginStatus == CommonStatus.loading;

    return FScaffold(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 150.h),
                Icon(FIcons.codesandbox, size: 70.r),
                SizedBox(height: 20.h),
                Text("Login"),
                SizedBox(height: 50.h),
                FTextFormField.email(
                  controller: _emailController,
                  hint: 'janedoe@foruslabs.com',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value?.contains('@') ?? false)
                      ? null
                      : 'Enter a valid email',
                ),
                SizedBox(height: 20.h),
                FTextFormField.password(
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => 8 <= (value?.length ?? 0)
                      ? null
                      : 'Password must be at least 8 characters',
                ),
                SizedBox(height: 40.h),
                isLoading
                    ? const CircularProgressIndicator()
                    : FButton(onPress: _login, child: const Text('Login')),
                if (authState.loginStatus == CommonStatus.failure &&
                    authState.error.consoleMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      authState.error.consoleMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
