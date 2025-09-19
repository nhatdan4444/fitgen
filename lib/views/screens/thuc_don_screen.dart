import 'package:fitgen/models/meal_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/food_entry.dart';

class ThucDonScreen extends StatefulWidget {
  const ThucDonScreen({super.key});

  @override
  State<ThucDonScreen> createState() => _ThucDonScreenState();
}

class _ThucDonScreenState extends State<ThucDonScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  String _fitnessMode = 'Giảm cân';
  final List<String> _fitnessModes = ['Giảm cân', 'Giữ cân', 'Tăng cân'];

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Lưu trữ dữ liệu
  final Map<String, List<MealEntry>> _mealsByDay = {};
  final Map<String, String> _modeByDay = {};
  final Map<String, String> _notesByDay = {};

  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Danh sách thực phẩm mẫu
  final List<FoodItem> _foodDatabase = [
    FoodItem(
      id: '1',
      name: 'Cơm trắng',
      calories: 130,
      protein: 2.7,
      carbs: 28.0,
      fat: 0.3,
      category: 'Tinh bột',
    ),
    FoodItem(
      id: '2',
      name: 'Thịt gà (ức)',
      calories: 165,
      protein: 31.0,
      carbs: 0.0,
      fat: 3.6,
      category: 'Protein',
    ),
    FoodItem(
      id: '3',
      name: 'Cá hồi',
      calories: 208,
      protein: 20.0,
      carbs: 0.0,
      fat: 13.0,
      category: 'Protein',
    ),
    FoodItem(
      id: '4',
      name: 'Trứng gà',
      calories: 155,
      protein: 13.0,
      carbs: 1.1,
      fat: 11.0,
      category: 'Protein',
    ),
    FoodItem(
      id: '5',
      name: 'Rau cải xanh',
      calories: 25,
      protein: 3.0,
      carbs: 5.0,
      fat: 0.3,
      fiber: 3.6,
      category: 'Rau củ',
    ),
    FoodItem(
      id: '6',
      name: 'Chuối',
      calories: 89,
      protein: 1.1,
      carbs: 23.0,
      fat: 0.3,
      fiber: 2.6,
      sugar: 12.0,
      category: 'Trái cây',
    ),
    FoodItem(
      id: '7',
      name: 'Yến mạch',
      calories: 389,
      protein: 17.0,
      carbs: 66.0,
      fat: 7.0,
      fiber: 10.0,
      category: 'Tinh bột',
    ),
    FoodItem(
      id: '8',
      name: 'Sữa chua Hy Lạp',
      calories: 59,
      protein: 10.0,
      carbs: 3.6,
      fat: 0.4,
      category: 'Sản phẩm từ sữa',
    ),
  ];

  List<FoodItem> _filteredFoods = [];
  // ignore: unused_field
  bool _isSearching = false;

  final List<String> _mealTypes = ['Sáng', 'Trưa', 'Tối', 'Phụ'];
  final List<IconData> _mealIcons = [
    Icons.wb_sunny_rounded,
    Icons.wb_sunny_outlined,
    Icons.nightlight_round,
    Icons.local_cafe_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _filteredFoods = _foodDatabase;
    _loadDataForDay();

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  void _loadDataForDay() {
    final key = _dateKey(_selectedDay);
    setState(() {
      _fitnessMode = _modeByDay[key] ?? 'Giảm cân';
      _noteController.text = _notesByDay[key] ?? '';
      if (!_mealsByDay.containsKey(key)) {
        _mealsByDay[key] = [];
      }
    });
  }

  void _pickDay() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF4CAF50)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
        _loadDataForDay();
      });
    }
  }

  void _searchFoods(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredFoods = _foodDatabase;
      } else {
        _filteredFoods = _foodDatabase
            .where(
              (food) =>
                  food.name.toLowerCase().contains(query.toLowerCase()) ||
                  food.category.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _addFoodToMeal(FoodItem food, String mealType, double quantity) {
    final key = _dateKey(_selectedDay);
    // ignore: unused_local_variable
    final nutrition = food.getNutritionForQuantity(quantity);
    final entry = MealEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      food: food,
      quantity: quantity,
      mealType: mealType,
      timestamp: DateTime.now(),
    );

    setState(() {
      _mealsByDay.putIfAbsent(key, () => []).add(entry);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${food.name} vào bữa $mealType'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _removeMealEntry(String entryId) {
    final key = _dateKey(_selectedDay);
    setState(() {
      _mealsByDay[key]?.removeWhere((entry) => entry.id == entryId);
    });
  }

  void _showAddFoodDialog(String mealType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddFoodBottomSheet(mealType),
    );
  }

  Widget _buildAddFoodBottomSheet(String mealType) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Thêm món ăn - Bữa $mealType',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: _searchFoods,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm thực phẩm...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchFoods('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _filteredFoods.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Không tìm thấy thực phẩm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredFoods.length,
                        itemBuilder: (context, index) {
                          final food = _filteredFoods[index];
                          return _buildFoodCard(food, mealType);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodCard(FoodItem food, String mealType) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(food.category).withOpacity(0.2),
                  _getCategoryColor(food.category).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(food.category),
              color: _getCategoryColor(food.category),
              size: 28,
            ),
          ),
          title: Text(
            food.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${food.calories.toInt()} kcal/100g',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'P: ${food.protein.toInt()}g | C: ${food.carbs.toInt()}g | F: ${food.fat.toInt()}g',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => _showQuantityDialog(food, mealType),
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFF4CAF50),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  void _showQuantityDialog(FoodItem food, String mealType) {
    final TextEditingController quantityController = TextEditingController(
      text: '100',
    );
    double quantity = 100;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Thêm ${food.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số lượng (grams)',
                  border: OutlineInputBorder(),
                  suffixText: 'g',
                ),
                onChanged: (value) {
                  setDialogState(() {
                    quantity = double.tryParse(value) ?? 100;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Dinh dưỡng cho ${quantity.toInt()}g',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calories: ${(food.calories * quantity / 100).toInt()} kcal',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Protein: ${(food.protein * quantity / 100).toInt()}g',
                        ),
                        Text(
                          'Carbs: ${(food.carbs * quantity / 100).toInt()}g',
                        ),
                        Text('Fat: ${(food.fat * quantity / 100).toInt()}g'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Close bottom sheet
                _addFoodToMeal(food, mealType, quantity);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Protein':
        return Colors.red;
      case 'Tinh bột':
        return Colors.orange;
      case 'Rau củ':
        return Colors.green;
      case 'Trái cây':
        return Colors.purple;
      case 'Sản phẩm từ sữa':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Protein':
        return Icons.restaurant_rounded;
      case 'Tinh bột':
        return Icons.rice_bowl_rounded;
      case 'Rau củ':
        return Icons.local_florist_rounded;
      case 'Trái cây':
        return Icons.apple_rounded;
      case 'Sản phẩm từ sữa':
        return Icons.local_drink_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  void _saveMenu() {
    final key = _dateKey(_selectedDay);
    setState(() {
      _modeByDay[key] = _fitnessMode;
      _notesByDay[key] = _noteController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã lưu thực đơn!'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  double _getTotalCalories() {
    final key = _dateKey(_selectedDay);
    final meals = _mealsByDay[key] ?? [];
    return meals.fold(0.0, (sum, meal) => sum + meal.calories);
  }

  Map<String, double> _getMacros() {
    final key = _dateKey(_selectedDay);
    final meals = _mealsByDay[key] ?? [];
    double protein = 0, carbs = 0, fat = 0;

    for (var meal in meals) {
      protein += meal.protein;
      carbs += meal.carbs;
      fat += meal.fat;
    }

    return {'protein': protein, 'carbs': carbs, 'fat': fat};
  }

  void _showMealTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Chọn bữa ăn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            ..._mealTypes.asMap().entries.map((entry) {
              final index = entry.key;
              final mealType = entry.value;
              final icon = _mealIcons[index];

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF4CAF50)),
                ),
                title: Text(
                  'Bữa $mealType',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showAddFoodDialog(mealType);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = _dateKey(_selectedDay);
    final todaysMeals = _mealsByDay[key] ?? [];
    final totalCalories = _getTotalCalories();
    final macros = _getMacros();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Custom Header
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 80, 155, 80),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 10),
                  child: Center(
                    child: Text(
                      'Kế Hoạch Ăn Uống',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  ),
                  onPressed: _pickDay,
                  tooltip: 'Chọn ngày',
                ),
              ],
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_selectedDay),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chế độ: $_fitnessMode',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'TỔNG',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${totalCalories.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'kcal',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildMacroInfo(
                                  'Protein',
                                  macros['protein']!,
                                  'g',
                                  Colors.red,
                                ),
                                _buildMacroInfo(
                                  'Carbs',
                                  macros['carbs']!,
                                  'g',
                                  Colors.orange,
                                ),
                                _buildMacroInfo(
                                  'Fat',
                                  macros['fat']!,
                                  'g',
                                  Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chế độ ăn uống',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _fitnessMode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              items: _fitnessModes
                                  .map(
                                    (mode) => DropdownMenuItem(
                                      value: mode,
                                      child: Text(mode),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _fitnessMode = value;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    ..._mealTypes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final mealType = entry.value;
                      final mealsOfType = todaysMeals
                          .where((meal) => meal.mealType == mealType)
                          .toList();

                      return SliverToBoxAdapter(
                        child: _buildMealSection(
                          mealType,
                          mealsOfType,
                          _mealIcons[index],
                        ),
                      );
                    }),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ghi chú',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Nhập ghi chú cho ngày này...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _saveMenu,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Lưu Thực Đơn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMealTypeSelector(),
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildMacroInfo(String label, double value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${value.toInt()}$unit',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    String mealType,
    List<MealEntry> meals,
    IconData icon,
  ) {
    final mealCalories = meals.fold(0.0, (sum, meal) => sum + meal.calories);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF4CAF50), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bữa $mealType',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${mealCalories.toInt()} kcal - ${meals.length} món',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddFoodDialog(mealType),
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: Color(0xFF4CAF50),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            if (meals.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Chưa có món ăn nào',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => _showAddFoodDialog(mealType),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Thêm món ăn'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: meals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final meal = entry.value;

                  return Dismissible(
                    key: Key(meal.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text('Xóa ${meal.food.name}'),
                          content: const Text(
                            'Bạn có chắc muốn xóa món ăn này?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      _removeMealEntry(meal.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xóa ${meal.food.name}'),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: _buildMealEntryCard(
                        meal,
                        index == meals.length - 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealEntryCard(MealEntry meal, bool isLast) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: isLast ? 12 : 0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(meal.food.category).withOpacity(0.2),
                  _getCategoryColor(meal.food.category).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getCategoryIcon(meal.food.category),
              color: _getCategoryColor(meal.food.category),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${meal.quantity.toInt()}g',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.calories.toInt()} kcal',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
              Text(
                'P:${meal.protein.toInt()} C:${meal.carbs.toInt()} F:${meal.fat.toInt()}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
