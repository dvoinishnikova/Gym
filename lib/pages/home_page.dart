import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_routes.dart';

class MyHomePage extends StatelessWidget {
  final Widget child;

  const MyHomePage({super.key, required this.child});

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoute.profile.path)) return 1;
    if (location.startsWith(AppRoute.settings.path)) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.home.path);
        break;
      case 1:
        context.go(AppRoute.profile.path);
        break;
      case 2:
        context.go(AppRoute.settings.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF202020),
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          const Text(
            "GymCon",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),

        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Головна",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Записатися",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Профіль",
          ),
        ],
      ),
    );
  }
}