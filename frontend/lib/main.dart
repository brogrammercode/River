import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forui/forui.dart';
import 'package:frontend/core/di/container.dart';
import 'package:frontend/core/config/routes/app_routes.dart';
import 'package:frontend/core/socket/socket.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Injections.init();
  _initializeSocket();
  runApp(const Application());
}

void _initializeSocket() {
  const serverUrl = 'https://river-production.up.railway.app';
  SocketService.instance.connect(serverUrl);
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FThemes.zinc.dark;

    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            supportedLocales: FLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              ...FLocalizations.localizationsDelegates,
            ],
            builder: (_, child) => FTheme(data: theme, child: child!),
            theme: theme.toApproximateMaterialTheme().copyWith(
              appBarTheme: AppBarTheme(
                systemOverlayStyle: commonSystemOverlay(context),
              ),
            ),
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}

SystemUiOverlayStyle commonSystemOverlay(BuildContext context) {
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
  );
}
