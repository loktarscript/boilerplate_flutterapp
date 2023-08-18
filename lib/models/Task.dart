class Task {
  final int id;
  final String content;
  final String icon;

  Task({
    required this.id,
    required this.content,
    required this.icon,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      content: map['content'],
      icon: map['icon'],
    );
  }
}
