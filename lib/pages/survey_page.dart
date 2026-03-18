import 'package:flutter/material.dart';
import 'survey_complete_page.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final List<String> goals = [
    "Набір м’язової маси",
    "Скидання ваги",
    "Покращення гнучкості",
    "Загальне зміцнення здоров’я",
  ];
  final Map<String, bool> selectedGoals = {};

  @override
  void initState() {
    super.initState();
    for (var goal in goals) {
      selectedGoals[goal] = false;
    }
  }

  void _submitSurvey() {
    final chosenGoals =
        selectedGoals.entries.where((e) => e.value).map((e) => e.key).toList();

    if (chosenGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Оберіть хоча б одну мету")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyCompletePage(userGoals: chosenGoals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF323232),
        title: const Text("Ваші цілі"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Оберіть ваші цілі тренувань:",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: goals.map((goal) {
                  return CheckboxListTile(
                    value: selectedGoals[goal],
                    onChanged: (value) {
                      setState(() {
                        selectedGoals[goal] = value ?? false;
                      });
                    },
                    title: Text(goal, style: const TextStyle(color: Colors.white)),
                    activeColor: const Color(0xFFED6E00),
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6E00),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submitSurvey,
              child: const Text(
                "Зберегти та продовжити",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}