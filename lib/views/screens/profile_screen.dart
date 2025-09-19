import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import '/utils/constants.dart';
import '/models/user_profile.dart';
import '/models/menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late UserProfileModel _userProfile;
  late List<List<MenuItemModel>> _menuSections;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeUserProfile();
    _initializeMenuItems();
    _controller.forward();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _initializeUserProfile() {
    _userProfile = UserProfileModel(
      name: 'Người dùng Demo',
      email: 'demo@email.com',
      dailyCalories: 1245,
      streakDays: 7,
      goalProgress: 85.0,
      phone: '0123456789',
      address: 'Hà Nội, Việt Nam',
      birthDate: DateTime(1999, 1, 1),
      healthGoals: ['Giảm cân', 'Tăng cơ bắp'],
      settings: {
        'height': 170.0,
        'weight': 65.0,
        'gender': 'Nam',
        'activityLevel': 'Trung bình',
      },
    );
  }

  void _initializeMenuItems() {
    _menuSections = [
      [
        MenuItemModel(
          title: 'Chỉnh sửa thông tin',
          icon: Icons.edit_outlined,
          color: Colors.blue,
          subtitle: 'Cập nhật cân nặng, chiều cao, BMI',
          routeName: '/edit-profile',
        ),
        MenuItemModel(
          title: 'Thông tin cá nhân',
          icon: Icons.person_outline,
          color: Colors.green,
          routeName: '/personal-info',
        ),
        MenuItemModel(
          title: 'Mục tiêu sức khỏe',
          icon: Icons.flag_outlined,
          color: Colors.orange,
          routeName: '/health-goals',
        ),
        MenuItemModel(
          title: 'Lịch sử ăn uống',
          icon: Icons.history,
          color: Colors.purple,
          routeName: '/eating-history',
        ),
      ],
      [
        MenuItemModel(
          title: 'Kết nối chuyên gia',
          icon: Icons.video_call,
          color: Colors.purple,
          subtitle: 'Tư vấn trực tuyến',
          isNew: true,
          routeName: '/expert-consultation',
        ),
        MenuItemModel(
          title: 'Kế hoạch dinh dưỡng',
          icon: Icons.restaurant_menu,
          color: Colors.teal,
          subtitle: 'Thực đơn cá nhân hóa',
          routeName: '/nutrition-plan',
        ),
      ],
      [
        MenuItemModel(
          title: 'Cài đặt',
          icon: Icons.settings_outlined,
          color: Colors.grey,
          routeName: '/settings',
        ),
        MenuItemModel(
          title: 'Thông báo',
          icon: Icons.notifications_outlined,
          color: Colors.amber,
          routeName: '/notifications',
        ),
        MenuItemModel(
          title: 'Trợ giúp & Hỗ trợ',
          icon: Icons.help_outline,
          color: Colors.indigo,
          routeName: '/help',
        ),
        MenuItemModel(
          title: 'Về FITGEN',
          icon: Icons.info_outline,
          color: Colors.cyan,
          routeName: '/about',
        ),
      ],
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildModernHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildHealthProfileCard(),
                        const SizedBox(height: 20),
                        _buildCalorieControlSection(),
                        const SizedBox(height: 32),
                        _buildSignOutButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 80, 155, 80),
            Color.fromARGB(255, 100, 175, 100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Hồ sơ người dùng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white, size: 24),
            onPressed: _showEditProfileDialog,
            tooltip: 'Chỉnh sửa hồ sơ',
          ),
        ],
      ),
    );
  }

  Widget _buildHealthProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernAvatar(),
          const SizedBox(height: 16),
          Text(
            _userProfile.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userProfile.email,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          _buildCalorieProgress(),
          const SizedBox(height: 20),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildModernAvatar() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 80, 155, 80),
                Color.fromARGB(255, 100, 175, 100),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.transparent,
            child: _userProfile.hasAvatar
                ? ClipOval(
                    child: Image.network(
                      _userProfile.avatarUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _changeAvatar,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 14,
                color: Color.fromARGB(255, 80, 155, 80),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calorie hôm nay',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _userProfile.dailyCalories.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 155, 80),
                      ),
                    ),
                    const TextSpan(
                      text: ' / 2591',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _userProfile.dailyCalories / 2591,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 80, 155, 80),
            ),
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${(2591 - _userProfile.dailyCalories).toInt()} calories còn lại',
              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn(
          '${_userProfile.streakDays}',
          'Ngày Streak',
          const Color.fromARGB(255, 80, 155, 80),
        ),
        _buildStatColumn(
          _calculateBMI(),
          'BMI',
          const Color.fromARGB(255, 80, 155, 80),
        ),
        _buildStatColumn(
          '${_userProfile.goalProgress.toInt()}%',
          'Mục tiêu',
          const Color.fromARGB(255, 80, 155, 80),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildCalorieControlSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 230, 200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Color.fromARGB(255, 80, 155, 80),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kiểm soát Calorie',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMenuTile(
            icon: Icons.calendar_today,
            title: 'Mục tiêu Calorie hàng ngày',
            subtitle: '2591 calories mỗi ngày',
            color: const Color.fromARGB(255, 80, 155, 80),
            onTap: () => _handleMenuNavigation('/daily-goal'),
          ),
          _buildMenuTile(
            icon: Icons.trending_up,
            title: 'Phân tích tiến độ',
            subtitle: 'Xem xu hướng calorie chi tiết',
            color: const Color.fromARGB(255, 80, 155, 80),
            onTap: () => _handleMenuNavigation('/progress-analytics'),
          ),
          _buildMenuTile(
            icon: Icons.restaurant_menu,
            title: 'Lập kế hoạch bữa ăn',
            subtitle: 'Lên kế hoạch bữa ăn hàng ngày',
            color: const Color.fromARGB(255, 80, 155, 80),
            onTap: () => _handleMenuNavigation('/meal-planning'),
          ),
          _buildMenuTile(
            icon: Icons.calendar_view_week,
            title: 'Tóm tắt hàng tuần',
            subtitle: '0 bản ghi tuần này',
            color: const Color.fromARGB(255, 80, 155, 80),
            onTap: () => _handleMenuNavigation('/weekly-summary'),
          ),
          const SizedBox(height: 16),
          ..._buildMenuSections(),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Điều hướng đến $title')));
            },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuSections() {
    final sectionTitles = ['Thông tin cá nhân', 'Dịch vụ', 'Cài đặt & Hỗ trợ'];

    return List.generate(_menuSections.length, (i) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12, top: 16),
            child: Text(
              sectionTitles[i],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          ..._menuSections[i].asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.2, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Interval(
                          0.1 * index,
                          0.5 + 0.1 * index,
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                child: _buildMenuItem(item),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildMenuItem(MenuItemModel item) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleMenuItemTap(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        if (item.isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'MỚI',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (item.hasSubtitle) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD1D5DB),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _signOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuNavigation(String route) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Điều hướng đến $route')));
  }

  void _handleMenuItemTap(MenuItemModel item) {
    if (item.routeName == '/edit-profile') {
      _showEditHealthInfoDialog();
    } else if (item.routeName == '/expert-consultation') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kết nối chuyên gia dinh dưỡng (coming soon)'),
          backgroundColor: Colors.purple,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Điều hướng đến ${item.title}')));
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userProfile.name);
    final emailController = TextEditingController(text: _userProfile.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chỉnh sửa hồ sơ cơ bản'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.dispose();
              emailController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _userProfile.updatePersonalInfo(
                newName: nameController.text,
                newEmail: emailController.text,
              );
              final errors = _userProfile.validate();
              if (errors.isEmpty) {
                setState(() {});
                nameController.dispose();
                emailController.dispose();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật thành công!')),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(errors.values.first)));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 80, 155, 80),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showEditHealthInfoDialog() {
    final height = _userProfile.getSetting<double>('height') ?? 0.0;
    final weight = _userProfile.getSetting<double>('weight') ?? 0.0;
    final gender = _userProfile.getSetting<String>('gender') ?? 'Nam';
    final activityLevel =
        _userProfile.getSetting<String>('activityLevel') ?? 'Trung bình';

    final heightController = TextEditingController(
      text: height > 0 ? height.toString() : '',
    );
    final weightController = TextEditingController(
      text: weight > 0 ? weight.toString() : '',
    );
    final nameController = TextEditingController(text: _userProfile.name);
    final emailController = TextEditingController(text: _userProfile.email);
    final phoneController = TextEditingController(
      text: _userProfile.phone ?? '',
    );
    final addressController = TextEditingController(
      text: _userProfile.address ?? '',
    );

    String selectedGender = gender;
    String selectedActivityLevel = activityLevel;
    DateTime? selectedBirthDate = _userProfile.birthDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Chỉnh sửa thông tin sức khỏe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate:
                          selectedBirthDate ??
                          DateTime.now().subtract(
                            const Duration(days: 365 * 25),
                          ),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365 * 100),
                      ),
                      lastDate: DateTime.now().subtract(
                        const Duration(days: 365 * 10),
                      ),
                    );
                    if (date != null) {
                      setDialogState(() {
                        selectedBirthDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake),
                        const SizedBox(width: 12),
                        Text(
                          selectedBirthDate != null
                              ? 'Ngày sinh: ${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'
                              : 'Chọn ngày sinh',
                          style: TextStyle(
                            color: selectedBirthDate != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Chiều cao (cm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.height),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cân nặng (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.monitor_weight),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Giới tính',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Nam', child: Text('Nam')),
                    DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedGender = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedActivityLevel,
                  decoration: InputDecoration(
                    labelText: 'Mức độ hoạt động',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.fitness_center),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Thấp',
                      child: Text('Thấp - Ít vận động'),
                    ),
                    DropdownMenuItem(
                      value: 'Trung bình',
                      child: Text('Trung bình - Vận động nhẹ'),
                    ),
                    DropdownMenuItem(
                      value: 'Cao',
                      child: Text('Cao - Vận động thường xuyên'),
                    ),
                    DropdownMenuItem(
                      value: 'Rất cao',
                      child: Text('Rất cao - Vận động nhiều'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedActivityLevel = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 200, 230, 200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'BMI tự động tính toán',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _calculateBMIFromInput(
                          heightController.text,
                          weightController.text,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 80, 155, 80),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                heightController.dispose();
                weightController.dispose();
                nameController.dispose();
                emailController.dispose();
                phoneController.dispose();
                addressController.dispose();
                Navigator.pop(context);
              },
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final inputHeight = double.tryParse(heightController.text);
                final inputWeight = double.tryParse(weightController.text);

                _userProfile.updatePersonalInfo(
                  newName: nameController.text,
                  newEmail: emailController.text,
                  newPhone: phoneController.text,
                  newAddress: addressController.text,
                  newBirthDate: selectedBirthDate,
                );

                if (inputHeight != null && inputHeight > 0) {
                  _userProfile.updateSetting('height', inputHeight);
                }
                if (inputWeight != null && inputWeight > 0) {
                  _userProfile.updateSetting('weight', inputWeight);
                }
                _userProfile.updateSetting('gender', selectedGender);
                _userProfile.updateSetting(
                  'activityLevel',
                  selectedActivityLevel,
                );

                final errors = _userProfile.validate();
                if (errors.isEmpty) {
                  setState(() {});
                  heightController.dispose();
                  weightController.dispose();
                  nameController.dispose();
                  emailController.dispose();
                  phoneController.dispose();
                  addressController.dispose();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cập nhật thông tin thành công!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errors.values.first),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 155, 80),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeAvatar() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Đổi ảnh đại diện',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Chụp ảnh'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _userProfile.avatarUrl = pickedFile.path;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật ảnh đại diện thành công!'),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _userProfile.avatarUrl = pickedFile.path;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật ảnh đại diện thành công!'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement sign out logic
              // AuthService.signOut();
              // Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  String _calculateBMI() {
    final height = _userProfile.getSetting<double>('height');
    final weight = _userProfile.getSetting<double>('weight');

    if (height != null && weight != null && height > 0 && weight > 0) {
      final heightInM = height / 100;
      final bmi = weight / (heightInM * heightInM);
      return bmi.toStringAsFixed(1);
    }
    return '0.0';
  }

  String _calculateBMIFromInput(String heightText, String weightText) {
    final height = double.tryParse(heightText);
    final weight = double.tryParse(weightText);

    if (height != null && weight != null && height > 0 && weight > 0) {
      final heightInM = height / 100;
      final bmi = weight / (heightInM * heightInM);
      return bmi.toStringAsFixed(1);
    }
    return '0.0';
  }
}
