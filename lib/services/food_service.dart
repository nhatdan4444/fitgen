import 'package:fitgen/models/food_entry.dart';

class FoodService {
  static final List<FoodItem> _foods = [
    // Fruits
    FoodItem(
      id: 'apple',
      name: 'Apple',
      calories: 52,
      protein: 0.3,
      carbs: 14,
      fat: 0.2,
      fiber: 2.4,
      sugar: 10.4,
      category: 'Fruits',
    ),
    FoodItem(
      id: 'banana',
      name: 'Banana',
      calories: 89,
      protein: 1.1,
      carbs: 23,
      fat: 0.3,
      fiber: 2.6,
      sugar: 12.2,
      category: 'Fruits',
    ),
    FoodItem(
      id: 'orange',
      name: 'Orange',
      calories: 47,
      protein: 0.9,
      carbs: 12,
      fat: 0.1,
      fiber: 2.4,
      sugar: 9.4,
      category: 'Fruits',
    ),

    // Vegetables
    FoodItem(
      id: 'broccoli',
      name: 'Broccoli',
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
      fiber: 2.6,
      sugar: 1.5,
      category: 'Vegetables',
    ),
    FoodItem(
      id: 'spinach',
      name: 'Spinach',
      calories: 23,
      protein: 2.9,
      carbs: 3.6,
      fat: 0.4,
      fiber: 2.2,
      sugar: 0.4,
      category: 'Vegetables',
    ),
    FoodItem(
      id: 'carrot',
      name: 'Carrot',
      calories: 41,
      protein: 0.9,
      carbs: 10,
      fat: 0.2,
      fiber: 2.8,
      sugar: 4.7,
      category: 'Vegetables',
    ),

    // Proteins
    FoodItem(
      id: 'chicken_breast',
      name: 'Chicken Breast (skinless)',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      fiber: 0,
      sugar: 0,
      category: 'Proteins',
    ),
    FoodItem(
      id: 'salmon',
      name: 'Salmon',
      calories: 208,
      protein: 20,
      carbs: 0,
      fat: 13,
      fiber: 0,
      sugar: 0,
      category: 'Proteins',
    ),
    FoodItem(
      id: 'eggs',
      name: 'Eggs (whole)',
      calories: 155,
      protein: 13,
      carbs: 1.1,
      fat: 11,
      fiber: 0,
      sugar: 1.1,
      category: 'Proteins',
    ),

    // Grains
    FoodItem(
      id: 'brown_rice',
      name: 'Brown Rice (cooked)',
      calories: 111,
      protein: 2.6,
      carbs: 23,
      fat: 0.9,
      fiber: 1.8,
      sugar: 0.4,
      category: 'Grains',
    ),
    FoodItem(
      id: 'oats',
      name: 'Oats',
      calories: 389,
      protein: 17,
      carbs: 66,
      fat: 7,
      fiber: 11,
      sugar: 1,
      category: 'Grains',
    ),
    FoodItem(
      id: 'quinoa',
      name: 'Quinoa (cooked)',
      calories: 120,
      protein: 4.4,
      carbs: 22,
      fat: 1.9,
      fiber: 2.8,
      sugar: 0.9,
      category: 'Grains',
    ),

    // Dairy
    FoodItem(
      id: 'milk',
      name: 'Milk (whole)',
      calories: 61,
      protein: 3.2,
      carbs: 4.8,
      fat: 3.3,
      fiber: 0,
      sugar: 5.1,
      category: 'Dairy',
    ),
    FoodItem(
      id: 'greek_yogurt',
      name: 'Greek Yogurt (plain)',
      calories: 97,
      protein: 18,
      carbs: 3.9,
      fat: 0.4,
      fiber: 0,
      sugar: 3.6,
      category: 'Dairy',
    ),

    // Nuts & Seeds
    FoodItem(
      id: 'almonds',
      name: 'Almonds',
      calories: 579,
      protein: 21,
      carbs: 22,
      fat: 50,
      fiber: 12,
      sugar: 4.4,
      category: 'Nuts & Seeds',
    ),
    FoodItem(
      id: 'walnuts',
      name: 'Walnuts',
      calories: 654,
      protein: 15,
      carbs: 14,
      fat: 65,
      fiber: 6.7,
      sugar: 2.6,
      category: 'Nuts & Seeds',
    ),
  ];

  static List<FoodItem> getAllFoods() {
    return List.unmodifiable(_foods);
  }

  static List<FoodItem> getPopularFoods() {
    return _foods.take(8).toList();
  }

  static List<FoodItem> searchFoods(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _foods.where((food) {
      return food.name.toLowerCase().contains(lowerQuery) ||
          food.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static List<FoodItem> getFoodsByCategory(String category) {
    return _foods.where((food) => food.category == category).toList();
  }

  static FoodItem? getFoodById(String id) {
    try {
      return _foods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> getCategories() {
    return _foods.map((food) => food.category).toSet().toList();
  }
}
