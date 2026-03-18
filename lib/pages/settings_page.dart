import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hasSubscription = false;
  DateTime? subscriptionEnd;

  void _buySubscription() {
    setState(() {
      hasSubscription = true;
      subscriptionEnd = DateTime.now().add(const Duration(days: 30));
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Абонемент активовано!")));
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ви вийшли з акаунту!"), duration: Duration(seconds: 1)),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
 
        context.go('/registration');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Ім’я Користувача", style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(12)),
              child: Text(
                hasSubscription ? "Дійсний до ${subscriptionEnd!.day}.${subscriptionEnd!.month}.${subscriptionEnd!.year}" : "Немає абонемента",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            if (!hasSubscription)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFED6E00), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _buySubscription,
                  child: const Text("Оплатити абонемент"),
                ),
              ),
            const SizedBox(height: 30),
            const Text("Історія тренувань", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Consumer<WorkoutProvider>(
              builder: (context, provider, _) {
                if (provider.workouts.isEmpty) {
                  return const Text("Немає тренувань", style: TextStyle(color: Colors.white70));
                }
                return Column(
                  children: provider.workouts.map((w) => ListTile(
                    title: Text(w.trainer, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${w.dateTime.day}.${w.dateTime.month}", style: const TextStyle(color: Colors.white70)),
                    trailing: Text("${w.dateTime.hour}:00", style: const TextStyle(color: Colors.white)),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _logout,
              child: const Text("Вийти з акаунту"),
            ),
          ],
        ),
      ),
    );
  }
}