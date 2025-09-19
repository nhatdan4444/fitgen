// lib/models/user_stats.dart
class UserStats {
  final int todayCalories;
  final int streakDays;
  final double goalPercentage;

  UserStats({
    required this.todayCalories,
    required this.streakDays,
    required this.goalPercentage,
  });

  // Sample data - replace with real data
  static UserStats getSampleData() {
    return UserStats(todayCalories: 1245, streakDays: 7, goalPercentage: 85.0);
  }
}
