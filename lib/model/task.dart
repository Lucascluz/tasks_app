class Task {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final String? updatedAt;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    this.completed = false,
  });


  factory Task.fromSqfliteDatabase(Map<String, dynamic> map) => Task(
        id: map["id"]?.toInt() ?? 0,
        title: map["title"] ?? "",
        description: map["description"] ?? "",
        createdAt: DateTime.fromMillisecondsSinceEpoch(map["created_at"] ?? 0)
            .toIso8601String(),
        updatedAt: map["updated_at"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map["updated_at"])
                .toIso8601String(),
        completed: map["completed"] == 1 ? true : false,
      );
}