import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app_routes.dart';

class SurveyCompletePage extends StatelessWidget {
  final List<String> userGoals;

  const SurveyCompletePage({super.key, required this.userGoals});

  Map<String, String> _getRecommendedTrainer() {
    if (userGoals.contains("Набір м’язової маси")) {
      return {
        "name": "Омелян",
        "type": "Набір м’язової маси",
        "image": "assets/trainer1.gif",
        "reason": "Він найкращий у силових тренуваннях!"
      };
    } else if (userGoals.contains("Скидання ваги")) {
      return {
        "name": "Карпо",
        "type": "Кросфіт / Кардіо",
        "image": "assets/trainer2.gif",
        "reason": "Його інтенсивні вправи спалять все зайве."
      };
    } else {
      return {
        "name": "Сніжана",
        "type": "Пілатес / Йога",
        "image": "assets/trainer3.gif",
        "reason": "Вона допоможе досягти гнучкості та спокою."
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainer = _getRecommendedTrainer();

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, color: Color(0xFFED6E00), size: 70),
              const SizedBox(height: 20),
              const Text(
                "Ми знайшли ідеального тренера!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF323232),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFED6E00), width: 1.5),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(trainer['image']!),
                      backgroundColor: Colors.grey[800],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      trainer['name']!,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      trainer['type']!,
                      style: const TextStyle(color: Color(0xFFED6E00), fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      trainer['reason']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED6E00),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go(AppRoute.home.path),
                child: const Text("На головну", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}