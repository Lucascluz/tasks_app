import "package:sqflite/sqflite.dart";
import "package:tasks_app/database/database_service.dart";
import "package:tasks_app/model/task.dart";

class TaskDB {
  static const tableName = "tasks";

  static Future<void> createTable(Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT "",
      createdAt INTEGER NOT NULL DEFAULT 0,
      updatedAt INTEGER,
      completed BOOLEAN NOT NULL DEFAULT false,
      UNIQUE (id)
    )
  """);
  }

  Future<int> create({
    required String title,
    String? description,
  }) async {
    final database = await DatabaseService().database;
    print("Creating task");
    return await database.rawInsert(
      """INSERT INTO $tableName (title, description, createdAt) VALUES (?,?,?)""",
      [title, description, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Task>> fetchAll() async {
    final database = await DatabaseService().database;
    final tasks = await database.rawQuery(
        """SELECT * from $tableName ORDER BY COALESCE(completed, updatedAt, createdAt, title)""");
    print("Tasks fetched");
    return tasks.map((task) => Task.fromSqfliteDatabase(task)).toList();
  }

  Future<Task> fetchById(int id) async {
    final database = await DatabaseService().database;
    final task = await database
        .rawQuery("""SELECT * from $tableName WHERE id = ?""", [id]);
    return Task.fromSqfliteDatabase(task.first);
  }

  Future<int> update({
    required int id,
    String? title,
    String? description,
    required bool completed,
  }) async {
    final database = await DatabaseService().database;
    print("Updating task $id");
    return await database.update(
      tableName,
      {
        if (title != null) "title": title,
        "description": description ?? "",
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
        "completed": completed ? true : false,
      },
      where: "id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(id) async {
    final database = await DatabaseService().database;
    await database.rawDelete("""DELETE FROM $tableName WHERE id = ?""", [id]);
  }
}
