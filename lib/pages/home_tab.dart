import 'package:flutter/material.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final int peopleCount = 60;
    final int maxPeople = 100;
    final double fillRatio = (peopleCount / maxPeople).clamp(0.0, 1.0);

    Color progressColor;
    String loadText;

    if (fillRatio < 0.33) {
      progressColor = Colors.green;
      loadText = "Низька навантаженість";
    } else if (fillRatio < 0.66) {
      progressColor = Colors.yellow;
      loadText = "Середня навантаженість";
    } else {
      progressColor = Colors.red;
      loadText = "Висока навантаженість";
    }

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Вітаємо, Ім’я!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Зараз у залі ",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    TextSpan(
                      text: "$peopleCount",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text: " людей",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final fullWidth = constraints.maxWidth;
                  final progressWidth = (peopleCount / maxPeople * fullWidth)
                      .clamp(0.0, fullWidth);

                  return Stack(
                    children: [
                      Container(
                        width: fullWidth,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9E9E9E),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      Container(
                        width: progressWidth,
                        height: 28,
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                loadText,
                style: TextStyle(
                  color: progressColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              Consumer<WorkoutProvider>(
                builder: (context, workoutProvider, child) {
                  final workouts = workoutProvider.workouts;

                  if (workouts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "У вас ще немає запланованих тренувань",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFAF3D00),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Тренування",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Тренер: ${workout.trainer}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${workout.dateTime.day}.${workout.dateTime.month}.${workout.dateTime.year} ${workout.dateTime.hour}:00",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  workoutProvider.removeWorkout(workout);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Тренування успішно відмінено",
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Відмінити",
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
