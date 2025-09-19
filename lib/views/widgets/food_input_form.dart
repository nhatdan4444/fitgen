import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/utils/constants.dart';
import '/models/food_entry.dart';
import '/providers/calorie_provider.dart';

class FoodInputForm extends StatefulWidget {
  const FoodInputForm({super.key});

  @override
  _FoodInputFormState createState() => _FoodInputFormState();
}

class _FoodInputFormState extends State<FoodInputForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  String _category = 'Meal';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
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
    _nameController.dispose();
    _caloriesController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories (kcal)'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  double.tryParse(value!) == null ? 'Invalid number' : null,
            ),
            const SizedBox(height: defaultPadding),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ['Meal', 'Snack', 'Fruit', 'Drink']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final entry = FoodEntry(
                    name: _nameController.text,
                    calories: double.parse(_caloriesController.text),
                    date: DateTime.now(),
                    category: _category,
                  );
                  Provider.of<CalorieProvider>(
                    context,
                    listen: false,
                  ).addFoodEntry(entry);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
