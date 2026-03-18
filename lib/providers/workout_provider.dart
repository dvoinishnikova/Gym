import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutProvider extends ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => List.unmodifiable(_workouts);

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }

  void removeWorkout(Workout workout) {
    _workouts.remove(workout);
    notifyListeners();
  }

  bool isSlotTaken(String trainer, DateTime date, int hour) {
    for (final w in _workouts) {
      if (w.trainer == trainer &&
          w.dateTime.year == date.year &&
          w.dateTime.month == date.month &&
          w.dateTime.day == date.day &&
          w.dateTime.hour == hour) {
        return true;
      }
    }
    return false;
  }
}