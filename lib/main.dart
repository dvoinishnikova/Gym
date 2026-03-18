import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/workout_provider.dart';
import 'pages/home_page.dart';
import 'pages/home_tab.dart';
import 'pages/trainers_page.dart';
import 'pages/settings_page.dart';
import 'pages/registration_page.dart';
import 'app_routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: const MyApp(),
    ),
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/registration',
  routes: [
    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MyHomePage(child: child),
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          builder: (context, state) => const HomeTab(),
        ),
        GoRoute(
          path: AppRoute.profile.path,
          builder: (context, state) => const TrainersPage(),
        ),
        GoRoute(
          path: AppRoute.settings.path,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF202020),
      ),
    );
  }
}