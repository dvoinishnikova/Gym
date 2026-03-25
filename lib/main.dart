import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/home_tab.dart';
import 'pages/trainers_page.dart';
import 'pages/settings_page.dart';
import 'pages/registration_page.dart';
import 'pages/login_page.dart';
import 'pages/survey_page.dart';
import 'pages/survey_complete_page.dart';
void main() {

 

  runApp(const MyApp());

}




final GoRouter router = GoRouter(
  initialLocation: '/registration',
  routes: [

    GoRoute(
      path: '/registration',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/survey',
      builder: (context, state) => const SurveyPage(),
    ),
    GoRoute(
      path: '/survey_complete',
      builder: (context, state) {
        final goals = state.extra as List<String>? ?? [];
        return SurveyCompletePage(userGoals: goals);
      },
    ),

    ShellRoute(
      builder: (context, state, child) => MyHomePage(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeTab()),
        GoRoute(path: '/profile', builder: (context, state) => const TrainersPage()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
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