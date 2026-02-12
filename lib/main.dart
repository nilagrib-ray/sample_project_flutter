import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/service_locator.dart';
import 'domain/repository/auth_repository.dart';
import 'navigation/app_navigation.dart';

// main() is the entry point: Dart runs this function first when the app starts.
void main() async {
  // Required before any async code in main. Ensures Flutter's engine is ready
  // (e.g. for plugins, native code, or shared preferences).
  WidgetsFlutterBinding.ensureInitialized();

  // Registers all services and repositories. When a screen needs a ViewModel or
  // repository, it gets it from here instead of creating it manually.
  setupServiceLocator();

  // Ask the auth repository if the user is already logged in (e.g. from a
  // previous session). If true, we skip the login screen and go straight to messages.
  final authRepository = getIt<AuthRepository>();
  final isLoggedIn = await authRepository.isLoggedIn();

  // Make the status bar (top bar with time, battery) transparent. Use dark icons
  // so they're visible on light backgrounds.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // runApp() starts the Flutter app. Everything you see on screen is built from
  // the widget tree that starts with SampleApp.
  runApp(SampleApp(isLoggedIn: isLoggedIn));
}

// Root widget of the app. It builds the MaterialApp and passes the router.
class SampleApp extends StatelessWidget {
  final bool isLoggedIn;

  const SampleApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Router is created with isLoggedIn so it knows where to send the user first.
    final router = createRouter(isLoggedIn: isLoggedIn);

    // MaterialApp.router: a Material Design app that uses GoRouter for navigation
    // instead of Navigator. The router decides which screen to show based on the URL.
    return MaterialApp.router(
      title: 'Party Hard Travel',
      debugShowCheckedModeBanner: false,
      // ThemeData: global styling for the whole app. Every screen inherits these
      // colors, fonts, and component styles unless overridden.
      theme: ThemeData(
        useMaterial3: true,
        // ColorScheme.fromSeed: generates a full color palette from one seed color.
        // App bars, buttons, links, etc. use these colors automatically.
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
