import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://unprayerfully-cnidophorous-loralee.ngrok-free.dev/api";

  static String? token;

  static Map<String, String> get headers => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  static Future<String?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: headers,
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      token = data["token"];
      return null;
    } else {
      return data["message"] ?? "Помилка логіну";
    }
  }

  static Future<String?> register(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: headers,
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      token = data["token"];
      return null;
    } else if (res.statusCode == 422) {
      return data["message"];
    } else {
      return "Помилка реєстрації";
    }
  }

  static Future<List<dynamic>> getTrainers() async {
    final res = await http.get(Uri.parse("$baseUrl/trainers"));
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getWorkouts() async {
    final res = await http.get(
      Uri.parse("$baseUrl/workouts"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  static Future<String?> createWorkout(
    int trainerId, String dateTime) async {
  try {
    final res = await http.post(
      Uri.parse("$baseUrl/workouts"),
      headers: headers,
      body: jsonEncode({
        "trainer_id": trainerId,
        "date_time": dateTime,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return null;
    }

    if (res.body.isNotEmpty) {
      final data = jsonDecode(res.body);
      return data["message"] ?? "Помилка створення";
    }

    return "Помилка сервера (${res.statusCode})";
  } catch (e) {
    return "Помилка з'єднання";
  }
}

  static Future<void> deleteWorkout(int id) async {
    await http.delete(
      Uri.parse("$baseUrl/workouts/$id"),
      headers: headers,
    );
  }
  static Future<Map<String, dynamic>?> getMe() async {
    final res = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return null;
    }
  }
  static Future<Map<String, dynamic>?> getGymLoad() async {
    final res = await http.get(
      Uri.parse("$baseUrl/gym-load"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return null;
    }
  }
  static Future<void> logout() async {
    await http.post(
      Uri.parse("$baseUrl/logout"),
      headers: headers,
    );

    token = null;
  }
  static Future<bool> paySubscription(int amount) async {
    final res = await http.post(
      Uri.parse('$baseUrl/pay'),
      headers: headers,
      body: jsonEncode({'amount': amount}),
    );

    print("PAY STATUS: ${res.statusCode}");
    print("PAY BODY: ${res.body}");

    return res.statusCode == 200;
  }
  static Future<List<String>> getTrainerSchedule(int trainerId) async {
  final res = await http.get(
    Uri.parse("$baseUrl/trainers/$trainerId/schedule"),
  );

  if (res.statusCode == 200) {
    return List<String>.from(jsonDecode(res.body));
  }

  return [];
}
}