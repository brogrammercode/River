import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late final FSelectController<String> _roleController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final roles = ["End User", "Receiver"];

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

  @override
  Widget build(BuildContext context) {
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
                Text("FItem"),
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
                FButton(
                  child: const Text('Register'),
                  onPress: () {
                    if (!_formKey.currentState!.validate()) return;
                    final role = _roleController.value;
                    log("Name: ${_nameController.text}");
                    log("Email: ${_emailController.text}");
                    log("Role: $role");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
