import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/trainer.dart';

final List<int> availableHours = [8, 10, 12, 14, 16, 18, 20];

class TrainersPage extends StatefulWidget {
  const TrainersPage({super.key});

  @override
  State<TrainersPage> createState() => _TrainersPageState();
}

class _TrainersPageState extends State<TrainersPage> {
  List<Trainer> trainers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainers();
  }

  Future<void> _loadTrainers() async {
    try {
      final data = await ApiService.getTrainers();
      setState(() {
        trainers = data.map<Trainer>((e) => Trainer.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<List<int>> _getFreeHours(int trainerId, DateTime date) async {
    final busyTimes = await ApiService.getTrainerSchedule(trainerId);
    final now = DateTime.now();

    return availableHours.where((hour) {
      final dateTime = DateTime(date.year, date.month, date.day, hour);

      if (dateTime.isBefore(now)) return false;

      final formatted = dateTime
          .toIso8601String()
          .substring(0, 19)
          .replaceAll('T', ' ');
      return !busyTimes.contains(formatted);
    }).toList();
  }

  Future<void> _bookTrainer(BuildContext context, Trainer trainer) async {
    final user = await ApiService.getMe();

    if (user == null || user['is_subscribed'] != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Потрібен абонемент ❌")));
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final freeHours = await _getFreeHours(trainer.id, date);
    if (freeHours.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Немає вільного часу 😢")));
      return;
    }

    final selectedHour = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Вибери годину"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: freeHours.map((hour) {
              return ListTile(
                title: Text("$hour:00"),
                onTap: () => Navigator.pop(context, hour),
              );
            }).toList(),
          ),
        );
      },
    );
    if (selectedHour == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, selectedHour);
    final formatted = dateTime
        .toIso8601String()
        .substring(0, 19)
        .replaceAll('T', ' ');

    final error = await ApiService.createWorkout(trainer.id, formatted);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Запис створено ✅")));
  }

  void _openDetails(BuildContext context, Trainer trainer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TrainerDetailsPage(trainer: trainer, getFreeHours: _getFreeHours),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                ...trainers.map(
                  (trainer) => Column(
                    children: [
                      TrainerCard(
                        trainer: trainer,
                        bookTrainer: _bookTrainer,
                        openDetails: _openDetails,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class TrainerCard extends StatelessWidget {
  final Trainer trainer;
  final Future<void> Function(BuildContext, Trainer) bookTrainer;
  final void Function(BuildContext, Trainer) openDetails;

  const TrainerCard({
    super.key,
    required this.trainer,
    required this.bookTrainer,
    required this.openDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDetails(context, trainer),
      child: Container(
        height: 170,
        decoration: const BoxDecoration(color: Color(0xFF323232)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://nonsignificative-nonappealingly-alexis.ngrok-free.dev${trainer.image}",
                    ),
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
                            trainer.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        Text(
                          trainer.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${trainer.experienceYears} років досвіду",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${trainer.clientsCount} клієнтів",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      trainer.type,
                      style: const TextStyle(
                        color: Colors.white,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => bookTrainer(context, trainer),
                          child: const Text(
                            "Записатися",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF7700)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => openDetails(context, trainer),
                          child: const Text(
                            "Деталі",
                            style: TextStyle(
                              color: Color(0xFFFF7700),
                              fontSize: 14,
                            ),
                          ),
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
  final Trainer trainer;
  final Future<List<int>> Function(int trainerId, DateTime date) getFreeHours;

  const TrainerDetailsPage({
    super.key,
    required this.trainer,
    required this.getFreeHours,
  });

  Future<void> _bookTrainer(BuildContext context) async {
    final user = await ApiService.getMe();

    if (user == null || user['is_subscribed'] != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Потрібен абонемент ❌")));
      return;
    }
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final freeHours = await getFreeHours(trainer.id, date);
    if (freeHours.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Немає вільного часу 😢")));
      return;
    }

    final selectedHour = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Вибери годину"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: freeHours.map((hour) {
              return ListTile(
                title: Text("$hour:00"),
                onTap: () => Navigator.pop(context, hour),
              );
            }).toList(),
          ),
        );
      },
    );
    if (selectedHour == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, selectedHour);
    final formatted = dateTime
        .toIso8601String()
        .substring(0, 19)
        .replaceAll('T', ' ');

    final error = await ApiService.createWorkout(trainer.id, formatted);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error == null ? "Запис успішний ✅" : error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(
        title: Text(trainer.name),
        backgroundColor: const Color(0xFF323232),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              "https://nonsignificative-nonappealingly-alexis.ngrok-free.dev${trainer.image}",
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(trainer.type, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            Text(
              "${trainer.experienceYears} років досвіду",
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              "${trainer.clientsCount} клієнтів",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              trainer.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Text(
              "Телефон: ${trainer.phone}",
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              "Telegram: ${trainer.telegram}",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6E00),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _bookTrainer(context),
              child: const Text(
                "Записатися",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
