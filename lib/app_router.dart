import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/home_tab.dart';
import 'pages/trainers_page.dart';
import 'pages/settings_page.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoute.home.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MyHomePage(child: child);
      },
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