class UserProfileModel {
  String name;
  String email;
  String? avatarUrl;
  int dailyCalories;
  int streakDays;
  double goalProgress;
  DateTime? birthDate;
  String? phone;
  String? address;
  List<String> healthGoals;
  Map<String, dynamic> settings;

  UserProfileModel({
    this.name = 'Người dùng Demo',
    this.email = 'demo@email.com',
    this.avatarUrl,
    this.dailyCalories = 1245,
    this.streakDays = 7,
    this.goalProgress = 85.0,
    this.birthDate,
    this.phone,
    this.address,
    List<String>? healthGoals,
    Map<String, dynamic>? settings,
  }) : healthGoals = healthGoals ?? [],
       settings = settings ?? {};

  // Getters
  String get displayName => name.isNotEmpty ? name : 'Người dùng';
  String get formattedGoalProgress => '${goalProgress.toInt()}%';
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  // Business logic methods
  void updatePersonalInfo({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newAddress,
    DateTime? newBirthDate,
  }) {
    if (newName != null && newName.isNotEmpty) name = newName;
    if (newEmail != null && newEmail.isNotEmpty) email = newEmail;
    if (newPhone != null) phone = newPhone;
    if (newAddress != null) address = newAddress;
    if (newBirthDate != null) birthDate = newBirthDate;
  }

  void updateStats({int? calories, int? streak, double? progress}) {
    if (calories != null && calories >= 0) dailyCalories = calories;
    if (streak != null && streak >= 0) streakDays = streak;
    if (progress != null && progress >= 0 && progress <= 100) {
      goalProgress = progress;
    }
  }

  void addHealthGoal(String goal) {
    if (goal.isNotEmpty && !healthGoals.contains(goal)) {
      healthGoals.add(goal);
    }
  }

  void removeHealthGoal(String goal) {
    healthGoals.remove(goal);
  }

  void updateSetting(String key, dynamic value) {
    settings[key] = value;
  }

  T? getSetting<T>(String key) {
    return settings[key] as T?;
  }

  // Validation methods
  bool isEmailValid() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isPhoneValid() {
    if (phone == null || phone!.isEmpty) return true; // Optional field
    return RegExp(
      r'^[0-9]{10,11}$',
    ).hasMatch(phone!.replaceAll(RegExp(r'[^\d]'), ''));
  }

  Map<String, String> validate() {
    Map<String, String> errors = {};

    if (name.trim().isEmpty) {
      errors['name'] = 'Tên không được để trống';
    }

    if (!isEmailValid()) {
      errors['email'] = 'Email không hợp lệ';
    }

    if (!isPhoneValid()) {
      errors['phone'] = 'Số điện thoại không hợp lệ';
    }

    return errors;
  }

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'dailyCalories': dailyCalories,
      'streakDays': streakDays,
      'goalProgress': goalProgress,
      'birthDate': birthDate?.toIso8601String(),
      'phone': phone,
      'address': address,
      'healthGoals': healthGoals,
      'settings': settings,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? 'Người dùng Demo',
      email: json['email'] ?? 'demo@email.com',
      avatarUrl: json['avatarUrl'],
      dailyCalories: json['dailyCalories'] ?? 1245,
      streakDays: json['streakDays'] ?? 7,
      goalProgress: (json['goalProgress'] ?? 85.0).toDouble(),
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      phone: json['phone'],
      address: json['address'],
      healthGoals: List<String>.from(json['healthGoals'] ?? []),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }
}
