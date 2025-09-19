import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils/constants.dart';
import '/providers/calorie_provider.dart';
import '../widgets/calorie_chart.dart';

// Enum for time periods
enum TimePeriod { daily, weekly, monthly, yearly }

// Enum for meal types
enum MealType { all, breakfast, lunch, dinner, snack }

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  TimePeriod _selectedPeriod = TimePeriod.daily;
  MealType _selectedMeal = MealType.all;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildModernCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: TimePeriod.values.map((period) {
          final isSelected = _selectedPeriod == period;
          String label;
          switch (period) {
            case TimePeriod.daily:
              label = 'Ngày';
              break;
            case TimePeriod.weekly:
              label = 'Tuần';
              break;
            case TimePeriod.monthly:
              label = 'Tháng';
              break;
            case TimePeriod.yearly:
              label = 'Năm';
              break;
          }

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF509B50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF509B50).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : textColor.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: MealType.values.map((meal) {
          final isSelected = _selectedMeal == meal;
          String label;
          IconData icon;

          switch (meal) {
            case MealType.all:
              label = 'Tất cả';
              icon = Icons.restaurant;
              break;
            case MealType.breakfast:
              label = 'Sáng';
              icon = Icons.free_breakfast;
              break;
            case MealType.lunch:
              label = 'Trưa';
              icon = Icons.lunch_dining;
              break;
            case MealType.dinner:
              label = 'Tối';
              icon = Icons.dinner_dining;
              break;
            case MealType.snack:
              label = 'Phụ';
              icon = Icons.cookie;
              break;
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMeal = meal;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF509B50) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF509B50)
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : textColor.withOpacity(0.7),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Map<String, dynamic> _calculateStats(CalorieProvider provider) {
    // This is a simplified calculation - you'll need to implement
    // the actual logic based on your data structure
    final totalCalories = provider.entries.fold(
      0.0,
      (sum, e) => sum + e.calories,
    );

    final averageDaily = provider.entries.isNotEmpty
        ? totalCalories / provider.entries.length
        : 0.0;

    final goalMetPercentage = provider.goal.dailyGoal > 0
        ? (provider.todayIntake / provider.goal.dailyGoal) * 100
        : 0.0;

    return {
      'totalCalories': totalCalories,
      'averageDaily': averageDaily,
      'goalMetPercentage': goalMetPercentage,
      'totalEntries': provider.entries.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalorieProvider>(context);
    final stats = _calculateStats(provider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Enhanced Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF509B50), Color(0xFF6BA76B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF509B50).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      const Text(
                        'Báo cáo dinh dưỡng',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildPeriodSelector(),
                ],
              ),
            ),

            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Filter
                      _buildModernCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lọc theo bữa ăn',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildMealSelector(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Stats Overview
                      _buildModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thống kê tổng quan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildStatCard(
                                  icon: Icons.local_fire_department,
                                  title: 'Tổng calo',
                                  value:
                                      '${stats['totalCalories'].toStringAsFixed(0)}',
                                  subtitle: 'kcal',
                                  iconColor: Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                _buildStatCard(
                                  icon: Icons.timeline,
                                  title: 'Trung bình',
                                  value:
                                      '${stats['averageDaily'].toStringAsFixed(0)}',
                                  subtitle: 'kcal/ngày',
                                  iconColor: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildStatCard(
                                  icon: Icons.flag,
                                  title: 'Đạt mục tiêu',
                                  value:
                                      '${stats['goalMetPercentage'].toStringAsFixed(0)}%',
                                  subtitle: 'hoàn thành',
                                  iconColor: stats['goalMetPercentage'] >= 100
                                      ? Colors.green
                                      : Colors.amber,
                                ),
                                const SizedBox(width: 12),
                                _buildStatCard(
                                  icon: Icons.restaurant_menu,
                                  title: 'Số bữa ăn',
                                  value: '${stats['totalEntries']}',
                                  subtitle: 'bữa ăn',
                                  iconColor: Colors.purple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Chart Section
                      _buildModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Biểu đồ calo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF509B50,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getPeriodLabel(),
                                    style: const TextStyle(
                                      color: Color(0xFF509B50),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CalorieChart(
                              period: _getPeriodString(),
                              mealType: _getMealTypeString(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Quick Actions
                      _buildModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thao tác nhanh',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    icon: Icons.share,
                                    label: 'Chia sẻ',
                                    onTap: () {
                                      // Implement share functionality
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    icon: Icons.file_download,
                                    label: 'Xuất PDF',
                                    onTap: () {
                                      // Implement PDF export
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    icon: Icons.insights,
                                    label: 'Chi tiết',
                                    onTap: () {
                                      // Navigate to detailed analytics
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF509B50), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case TimePeriod.daily:
        return 'Theo ngày';
      case TimePeriod.weekly:
        return 'Theo tuần';
      case TimePeriod.monthly:
        return 'Theo tháng';
      case TimePeriod.yearly:
        return 'Theo năm';
    }
  }

  String _getPeriodString() {
    switch (_selectedPeriod) {
      case TimePeriod.daily:
        return 'daily';
      case TimePeriod.weekly:
        return 'weekly';
      case TimePeriod.monthly:
        return 'monthly';
      case TimePeriod.yearly:
        return 'yearly';
    }
  }

  String _getMealTypeString() {
    switch (_selectedMeal) {
      case MealType.all:
        return 'all';
      case MealType.breakfast:
        return 'breakfast';
      case MealType.lunch:
        return 'lunch';
      case MealType.dinner:
        return 'dinner';
      case MealType.snack:
        return 'snack';
    }
  }
}
