class User {
  DateTime createdAt;
  String email;
  String hashedPassword;
  String id;
  bool isAdmin;
  DateTime lastStreak;
  int level;
  String name;
  int streak;
  int xp;
  int xpToLevelUp;

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
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      email: json['email'] ?? '',
      hashedPassword: json['hashed_password'] ?? '',
      id: json['id'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      lastStreak: DateTime.parse(json['last_streak'] ?? ''),
      level: json['level'] ?? 0,
      name: json['name'] ?? '',
      streak: json['streak'] ?? 0,
      xp: json['xp'] ?? 0,
      xpToLevelUp: json['xp_to_level_up'] ?? 0,
    );
  }
}
