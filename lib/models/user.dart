class User {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String? role;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['contact']?['phone'],
      role: json['role'],
    );
  }
}
