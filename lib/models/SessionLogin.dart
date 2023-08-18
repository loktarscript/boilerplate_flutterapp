class SessionLogin {
  final int id;
  final int userId;
  final String date;
  final bool isActive;

  SessionLogin({
    required this.id,
    required this.userId,
    required this.date,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'is_active': isActive ? 1 : 0,
    };
  }
}
