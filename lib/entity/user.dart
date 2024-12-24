class User {
  final String createdAt;
  final String email;
  final String hashedPassword;
  final String id;
  final bool isAdmin;
  final String lastStreak;
  final int level;
  final String name;
  final int streak;
  final int xp;
  final int xpToLevelUp;

  User({
    required this.createdAt,
    required this.email,
    required this.hashedPassword,
    required this.id,
    required this.isAdmin,
    required this.lastStreak,
    required this.level,
    required this.name,
    required this.streak,
    required this.xp,
    required this.xpToLevelUp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      createdAt: json['created_at'] ?? '',
      email: json['email'] ?? '',
      hashedPassword: json['hashed_password'] ?? '',
      id: json['id'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      lastStreak: json['last_streak'] ?? '',
      level: json['level'] ?? 0,
      name: json['name'] ?? '',
      streak: json['streak'] ?? 0,
      xp: json['xp'] ?? 0,
      xpToLevelUp: json['xp_to_level_up'] ?? 0,
    );
  }
}
