import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                FButton(
                  child: const Text('Login'),
                  onPress: () {
                    if (!_formKey.currentState!.validate()) return;
                    log("Email: ${_emailController.text}");
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
