class User {
  final int? id;
  final String name;
  final String email;
  final String colorSettings;
  final int is_active;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.colorSettings,
    required this.is_active
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'color_settings': colorSettings,
      'is_active': is_active
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        colorSettings = map['color_settings'],
        is_active = map['is_active'];
}
