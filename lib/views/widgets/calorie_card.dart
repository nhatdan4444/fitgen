import 'package:flutter/material.dart';
import '/utils/constants.dart';

class CalorieCard extends StatelessWidget {
  final String title;
  final double calories;
  final double goal;

  const CalorieCard({
    super.key,
    required this.title,
    required this.calories,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: textColor),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              'Calories: ${calories.toStringAsFixed(0)} kcal',
              style: const TextStyle(color: textColor),
            ),
            Text(
              'Goal: ${goal.toStringAsFixed(0)} kcal',
              style: const TextStyle(color: textColor),
            ),
            const SizedBox(height: defaultPadding / 2),
            LinearProgressIndicator(
              value: calories / goal,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}
