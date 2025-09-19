import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '/utils/constants.dart';
import '../widgets/food_input_form.dart';
import '/models/food_entry.dart';
import '/providers/calorie_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _analyzeFoodImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final inputImage = InputImage.fromFilePath(image.path);
    final options = ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    final labels = await imageLabeler.processImage(inputImage);
    imageLabeler.close();

    if (labels.isNotEmpty) {
      final foodLabel = labels.first.label; // e.g., "Pho" or "Apple"
      _getNutritionFromSpoonacular(foodLabel);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không nhận diện được món ăn')),
        );
      }
    }
  }

  Future<void> _getNutritionFromSpoonacular(String foodLabel) async {
    const apiKey = 'YOUR_SPOONACULAR_API_KEY'; // Replace with real API key
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/guessNutrition?apiKey=$apiKey&title=$foodLabel',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final calories = data['calories']['value'].toDouble();
        final category = data['dietLabels'][0] ?? 'Meal'; // Example parsing

        final entry = FoodEntry(
          name: foodLabel,
          calories: calories,
          date: DateTime.now(),
          category: category,
        );
        Provider.of<CalorieProvider>(
          context,
          listen: false,
        ).addFoodEntry(entry);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã thêm món ăn từ ảnh')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi lấy dữ liệu dinh dưỡng')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Kết nối thất bại')));
      }
    }
  }

  Widget modernCard({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Thêm Món Ăn'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            modernCard(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Phân tích món ăn qua ảnh'),
                onPressed: _analyzeFoodImage,
              ),
            ),
            const SizedBox(height: defaultPadding),
            const FoodInputForm(), // Manual input remains
          ],
        ),
      ),
    );
  }
}
