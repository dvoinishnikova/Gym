import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<dynamic> workouts = [];
  Map<String, dynamic>? gym;
  String? userName;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final workoutsData = await ApiService.getWorkouts();
      final gymData = await ApiService.getGymLoad();
      final user = await ApiService.getMe();

      final now = DateTime.now();

setState(() {
  workouts = (workoutsData ?? []).where((w) {
    final date = DateTime.parse(w["date_time"]);
    return date.isAfter(now);
  }).toList();


  workouts.sort((a, b) =>
      DateTime.parse(a["date_time"])
          .compareTo(DateTime.parse(b["date_time"])));

  gym = gymData;
  userName = user?['name'];
  _isLoading = false;
});
    } catch (e) {
      print("ERROR: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteWorkout(int id) async {
    try {
      await ApiService.deleteWorkout(id);


      await _loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Запис скасовано ❌")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Помилка: $e")),
      );
    }
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Відмінити запис?"),
        content: const Text("Ви впевнені, що хочете скасувати тренування?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Ні"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Так"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteWorkout(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int peopleCount = gym?["people_now"] ?? 0;
    final String approx = gym?["approx"] ?? "Завантаження...";
    final String status = gym?["status"] ?? "";

    final int maxPeople = 100;
    final double fillRatio =
        (peopleCount / maxPeople).clamp(0.0, 1.0);

    Color progressColor;

    if (fillRatio < 0.33) {
      progressColor = Colors.green;
    } else if (fillRatio < 0.66) {
      progressColor = Colors.yellow;
    } else {
      progressColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName != null
                          ? "Вітаємо, $userName 👋"
                          : "Вітаємо 👋",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Зараз у залі $approx",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final fullWidth = constraints.maxWidth;
                        final progressWidth =
                            fullWidth * fillRatio;

                        return Stack(
                          children: [
                            Container(
                              width: fullWidth,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Container(
                              width: progressWidth,
                              height: 25,
                              decoration: BoxDecoration(
                                color: progressColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    Text(
                      status,
                      style: TextStyle(color: progressColor),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Мої тренування",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: workouts.isEmpty
                          ? const Center(
                              child: Text(
                                "Немає записів",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : ListView.builder(
                              itemCount: workouts.length,
                              itemBuilder: (context, index) {
                                final w = workouts[index];

                                return Card(
                                  color: Colors.grey[800],
                                  margin:
                                      const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text(
                                      w["trainer"]["name"],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      w["date_time"],
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          _confirmDelete(w["id"]),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}