class Task {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final String? updatedAt;
  final String? dueDate;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    this.completed = false,
  });

  bool isLate() {
    if (dueDate != null) {
      DateTime currentDate = DateTime.now();
      DateTime taskDueDate = DateTime.parse(dueDate!);
      return taskDueDate.isBefore(currentDate);
    }
    return false;
  }

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
        dueDate: map["due_date"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map["due_date"])
                .toIso8601String(),
        completed: map["completed"] == 1 ? true : false,
      );
}