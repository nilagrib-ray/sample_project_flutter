import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/service_locator.dart';
import 'domain/repository/auth_repository.dart';
import 'navigation/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI (equivalent of Hilt)
  setupServiceLocator();

  // Check login state
  final authRepository = getIt<AuthRepository>();
  final isLoggedIn = await authRepository.isLoggedIn();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(SampleApp(isLoggedIn: isLoggedIn));
}

class SampleApp extends StatelessWidget {
  final bool isLoggedIn;

  const SampleApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(isLoggedIn: isLoggedIn);

    return MaterialApp.router(
      title: 'Party Hard Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6600),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
