import 'package:fitgen/models/food_entry.dart';
// ignore: unused_import
import 'package:uuid/uuid.dart';

class MealEntry {
  final String id;
  final FoodItem food;
  final double quantity;
  final String mealType;
  final DateTime timestamp;

  MealEntry({
    required this.id,
    required this.food,
    required this.quantity,
    required this.mealType,
    required this.timestamp,
  });

  double get calories => food.calories * (quantity / 100);
  double get protein => food.protein * (quantity / 100);
  double get carbs => food.carbs * (quantity / 100);
  double get fat => food.fat * (quantity / 100);
}
