import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/workout.dart';

class TrainersPage extends StatelessWidget {
  const TrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Наші тренери",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          TrainerCard(
            name: "Омелян",
            type: "Набір м’язової маси",
            imagePath: "assets/trainer1.gif",
            experienceYears: 8,
            clientsCount: 40,
            rating: 5.0,
            description:
                "Омелян спеціалізується на наборі м’язової маси. Використовує сучасні методики тренувань та харчування для максимального результату.",
            phone: "+380501234567",
            telegram: "@omelyan_fit",
          ),
          const SizedBox(height: 20),
          TrainerCard(
            name: "Карпо",
            type: "Кросфіт",
            imagePath: "assets/trainer2.gif",
            experienceYears: 5,
            clientsCount: 25,
            rating: 4.7,
            description:
                "Карпо — експерт у кросфіті. Проводить інтенсивні тренування, що поєднують силові та кардіо вправи для всебічного розвитку.",
            phone: "+380671234567",
            telegram: "@karpo_crossfit",
          ),
          const SizedBox(height: 20),
          TrainerCard(
            name: "Сніжана",
            type: "Пілатес",
            imagePath: "assets/trainer3.gif",
            experienceYears: 6,
            clientsCount: 30,
            rating: 4.9,
            description:
                "Сніжана спеціалізується на пілатесі та розвитку гнучкості. Тренування допомагають зміцнити м’язи та покращити поставу.",
            phone: "+380631234567",
            telegram: "@snizhana_pilates",
          ),
          const SizedBox(height: 20),
          TrainerCard(
            name: "Пилип",
            type: "Пілатес",
            imagePath: "assets/trainer4.gif",
            experienceYears: 4,
            clientsCount: 18,
            rating: 4.5,
            description:
                "Пилип проводить пілатес-тренування для початківців та просунутих. Його заняття поєднують вправи на баланс та силу.",
            phone: "+380681234567",
            telegram: "@pylip_pilates",
          ),
          const SizedBox(height: 20),
          TrainerCard(
            name: "Микола",
            type: "Пілатес",
            imagePath: "assets/trainer5.gif",
            experienceYears: 7,
            clientsCount: 35,
            rating: 4.8,
            description:
                "Микола допомагає покращити фізичну форму та гнучкість. Його заняття включають персональні та групові тренування.",
            phone: "+380691234567",
            telegram: "@mykola_fit",
          ),
        ],
      ),
    );
  }
}

class TrainerCard extends StatelessWidget {
  final String name;
  final String type;
  final String imagePath;
  final int experienceYears;
  final int clientsCount;
  final double rating;
  final String description;
  final String phone;
  final String telegram;

  const TrainerCard({
    super.key,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.experienceYears,
    required this.clientsCount,
    required this.rating,
    required this.description,
    required this.phone,
    required this.telegram,
  });

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerDetailsPage(
          name: name,
          type: type,
          imagePath: imagePath,
          experienceYears: experienceYears,
          clientsCount: clientsCount,
          rating: rating,
          description: description,
          phone: phone,
          telegram: telegram,
        ),
      ),
    );
  }

  static Future<void> bookTrainer(BuildContext context, String trainerName) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate == null) return;

    int? selectedHour = await showDialog<int>(
      context: context,
      builder: (context) {
        final workoutProvider = context.read<WorkoutProvider>();
        final now = DateTime.now();

        return SimpleDialog(
          title: const Text("Виберіть час"),
          children: List.generate(5, (index) {
            final hour = 10 + index * 2;
            final isPastTime = selectedDate.year == now.year &&
                selectedDate.month == now.month &&
                selectedDate.day == now.day &&
                hour <= now.hour;
            final isTaken = workoutProvider.isSlotTaken(trainerName, selectedDate, hour) || isPastTime;

            return SimpleDialogOption(
              onPressed: isTaken ? null : () => Navigator.pop(context, hour),
              child: Text(
                "$hour:00${isTaken ? " (зайнято)" : ""}",
                style: TextStyle(color: isTaken ? Colors.grey : Colors.white),
              ),
            );
          }),
        );
      },
    );

    if (selectedHour == null) return;

    final workoutDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedHour,
    );

    context.read<WorkoutProvider>().addWorkout(
      Workout(trainer: trainerName, dateTime: workoutDateTime),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Записано на ${selectedDate.day}.${selectedDate.month}.${selectedDate.year} о $selectedHour:00",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        height: 170,
        decoration: BoxDecoration(color: const Color(0xFF323232)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$experienceYears років досвіду",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      "$clientsCount клієнтів",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFED6E00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () => bookTrainer(context, name),
                          child: const Text("Записатися", style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF7700)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () => _openDetails(context),
                          child: const Text("Деталі", style: TextStyle(color: Color(0xFFFF7700), fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainerDetailsPage extends StatelessWidget {
  final String name;
  final String type;
  final String imagePath;
  final int experienceYears;
  final int clientsCount;
  final double rating;
  final String description;
  final String phone;
  final String telegram;

  const TrainerDetailsPage({
    super.key,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.experienceYears,
    required this.clientsCount,
    required this.rating,
    required this.description,
    required this.phone,
    required this.telegram,
  });

  Future<void> _bookTrainer(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    int? selectedHour = await showDialog<int>(
      context: context,
      builder: (context) {
        final workoutProvider = context.read<WorkoutProvider>();
        final now = DateTime.now();

        return SimpleDialog(
          title: const Text("Виберіть час"),
          children: List.generate(5, (index) {
            final hour = 10 + index * 2;
            final isPastTime = selectedDate.year == now.year &&
                selectedDate.month == now.month &&
                selectedDate.day == now.day &&
                hour <= now.hour;
            final isTaken = workoutProvider.isSlotTaken(name, selectedDate, hour) || isPastTime;

            return SimpleDialogOption(
              onPressed: isTaken ? null : () => Navigator.pop(context, hour),
              child: Text(
                "$hour:00${isTaken ? " (зайнято)" : ""}",
                style: TextStyle(color: isTaken ? Colors.grey : Colors.white),
              ),
            );
          }),
        );
      },
    );

    if (selectedHour == null) return;

    final workoutDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedHour,
    );

    context.read<WorkoutProvider>().addWorkout(
      Workout(trainer: name, dateTime: workoutDateTime),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Записано на ${selectedDate.day}.${selectedDate.month}.${selectedDate.year} о $selectedHour:00",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF323232),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(imagePath, width: 200, height: 200),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 10),
            Text(type, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            Text("$experienceYears років досвіду", style: const TextStyle(color: Colors.white70)),
            Text("$clientsCount клієнтів", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Text(description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Text("Телефон: $phone", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
            Text("Telegram: $telegram", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6E00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => _bookTrainer(context),
              child: const Text("Записатися"),
            ),
          ],
        ),
      ),
    );
  }
}