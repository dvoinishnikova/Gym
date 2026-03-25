import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isPayLoading = false;
  bool _isLogoutLoading = false;
  bool _isUserLoading = true;

  String? userName;
  String? userEmail;

  List<dynamic> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await ApiService.getMe();
      final workoutsData = await ApiService.getWorkouts();

      if (user == null) {
        context.go('/login');
        return;
      }

      final now = DateTime.now();

setState(() {
  userName = user['name'];
  userEmail = user['email'];

  workouts = (workoutsData ?? []).where((w) {
    final date = DateTime.parse(w["date_time"]);
    return date.isBefore(now);
  }).toList();

  _isUserLoading = false;
});
    } catch (e) {
      print("ERROR: $e");
      setState(() => _isUserLoading = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _isLogoutLoading = true);

    await ApiService.logout();

    setState(() => _isLogoutLoading = false);

    context.go('/login');
  }

  Future<void> _paySubscription() async {
    setState(() => _isPayLoading = true);

    try {
      final success = await ApiService.paySubscription(10000);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "Оплачено ✅" : "Помилка оплати ❌"),
        ),
      );
    } catch (e) {
      print("PAY ERROR: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Помилка: $e")));
    }

    setState(() => _isPayLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF202020),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    userEmail ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Історія тренувань",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            workouts.isEmpty
                ? const Text(
                    "Немає записів",
                    style: TextStyle(color: Colors.white70),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final w = workouts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            w["trainer"]["name"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            w["date_time"],
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 30),

            const Text(
              "Абонемент",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _isPayLoading ? null : _paySubscription,
              child: _isPayLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Оплатити абонемент"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLogoutLoading ? null : _logout,
              child: _isLogoutLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Вийти"),
            ),
          ],
        ),
      ),
    );
  }
}