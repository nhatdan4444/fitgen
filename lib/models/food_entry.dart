import 'package:uuid/uuid.dart';

class FoodEntry {
  final String id;
  final String name;
  final double calories;
  final DateTime date;
  final String category;

  FoodEntry({
    String? id,
    required this.name,
    required this.calories,
    required this.date,
    required this.category,
  }) : id = id ?? const Uuid().v4();
}

class FoodItem {
  final String id;
  final String name;
  final double calories; // per 100g
  final double protein; // grams per 100g
  final double carbs; // grams per 100g
  final double fat; // grams per 100g
  final double fiber; // grams per 100g
  final double sugar; // grams per 100g
  final String category;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
    this.sugar = 0.0,
    this.category = 'General',
  });

  // Calculate nutrition for a specific quantity (in grams)
  Map<String, double> getNutritionForQuantity(double grams) {
    final factor = grams / 100.0;
    return {
      'calories': calories * factor,
      'protein': protein * factor,
      'carbs': carbs * factor,
      'fat': fat * factor,
      'fiber': fiber * factor,
      'sugar': sugar * factor,
    };
  }

  double getCaloriesForQuantity(double grams) {
    return calories * (grams / 100.0);
  }
}
