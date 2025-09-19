// New file for displaying personalized meal plan from Spoonacular
import 'package:flutter/material.dart';
import '/utils/constants.dart';

class MealPlanScreen extends StatelessWidget {
  final Map<String, dynamic> mealData; // Data passed from Dashboard

  const MealPlanScreen({super.key, required this.mealData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực Đơn Cá Nhân Hóa'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView.builder(
          itemCount: mealData['meals'].length,
          itemBuilder: (context, index) {
            final meal = mealData['meals'][index];
            return ListTile(
              title: Text(
                meal['title'],
                style: const TextStyle(color: textColor),
              ),
              subtitle: Text('Sẵn sàng trong ${meal['readyInMinutes']} phút'),
              // Add more details like calories from mealData['nutrients']
            );
          },
        ),
      ),
    );
  }
}
