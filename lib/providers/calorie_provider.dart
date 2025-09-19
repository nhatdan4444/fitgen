import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import '../models/calories_goal.dart';

class CalorieProvider extends ChangeNotifier {
  final List<FoodEntry> _entries = [];
  CalorieGoal _goal = CalorieGoal(dailyGoal: 2000, date: DateTime.now());

  List<FoodEntry> get entries => _entries;
  CalorieGoal get goal => _goal;

  double get todayIntake {
    final today = DateTime.now();
    return _entries
        .where(
          (e) =>
              e.date.year == today.year &&
              e.date.month == today.month &&
              e.date.day == today.day,
        )
        .fold(0, (sum, e) => sum + e.calories);
  }

  void addFoodEntry(FoodEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void updateGoal(double newGoal) {
    _goal = CalorieGoal(dailyGoal: newGoal, date: DateTime.now());
    notifyListeners();
  }
}
