import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/config/routes/app_routes.dart';
import 'package:frontend/core/error/common_error.dart';
import 'package:frontend/core/providers/providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late final FSelectController<String> _roleController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final roles = ["Consumer", "Receiver"];

  @override
  void initState() {
    super.initState();
    _roleController = FSelectController<String>(vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authNotifierProvider.notifier);

    try {
      await notifier.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _roleController.value ?? "Consumer",
      );

      final user = ref.read(authNotifierProvider).user;
      log(
        "Register success: UserID=${user?.id}, Name=${user?.name}, Email=${user?.email}",
      );
      if (user?.name != null) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, "/items", (route) => false);
      }
    } catch (e) {
      log("Login error: $e");
      if (!mounted) return;
      FToast(title: Text("Login Error"), description: Text(e.toString()));
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
                const Text("Register"),
                SizedBox(height: 50.h),
                FTextFormField(
                  label: const Text("Name"),
                  controller: _nameController,
                  hint: 'janedoe',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value != null && value.isNotEmpty)
                      ? null
                      : 'Enter a name',
                ),
                SizedBox(height: 20.h),
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
                SizedBox(height: 20.h),
                FSelect<String>(
                  label: const Text("Select Role"),
                  hint: 'Select a role',
                  controller: _roleController,
                  format: (s) => s,
                  children: [for (final role in roles) FSelectItem(role, role)],
                ),
                SizedBox(height: 40.h),
                isLoading
                    ? const CircularProgressIndicator()
                    : FButton(
                        onPress: _register,
                        child: const Text('Register'),
                      ),
                if (authState.loginStatus == CommonStatus.failure &&
                    authState.error.consoleMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      authState.error.consoleMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                SizedBox(height: 20.h),
                FButton(
                  style: FButtonStyle.secondary(),
                  onPress: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: Text("Login instead"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
