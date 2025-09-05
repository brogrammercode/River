import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';
import 'package:frontend/features/items/presentation/pages/items_page.dart';

class AppRoutes {
  static const String core = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String items = '/items';
  static const String addItem = '/addItem';

  // route
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case core:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case items:
        return MaterialPageRoute(builder: (_) => const ItemsPage());
      case addItem:

      // default
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }

  static Future<void> navigateTo(
    BuildContext context,
    String routeName,
    Object? arguments,
  ) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<void> replaceWith(BuildContext context, String routeName) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}
