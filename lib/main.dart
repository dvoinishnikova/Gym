import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final themeProvider = ThemeProvider();
          themeProvider.getDarkTheme();
          return themeProvider;
        }),
      ],
      child: const MyApp(),
    ),
  );
}