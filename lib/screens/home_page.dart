import 'package:flutter/material.dart';
import 'package:tasks_app/constants/colors.dart';
import 'package:tasks_app/database/task_db.dart';
import 'package:tasks_app/model/task.dart';
import 'package:tasks_app/widgets/create_task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Task>>? futureTasks;
  final taskDB = TaskDB();

  @override
  void initState() {
    super.initState();

    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTasks = taskDB.fetchAll();
    });
  }

  bool darkMode = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor:
            darkMode ? DarkModeBackgroundColor : LightModeBackgroundColor,
        appBar: AppBar(
          title: const Text(
            "Task List",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: darkMode ? DarkerGray : AccentColor,
          actions: [
            Switch(
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Task>>(
          future: futureTasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final List<Task>? tasks = snapshot.data;

              if (tasks == null || tasks.isEmpty) {
                return Center(
                  child: Text(
                    "No Tasks Found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      onTap: () async {
                        await taskDB.update(
                          id: task.id,
                          title: task.title,
                          description: task.description,
                          completed: task.completed ? false : true,
                        );
                        fetchTodos();
                      },
                      title: Text(
                        task.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed
                                ? DarkGray
                                : darkMode
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        task.description,
                        style: TextStyle(
                            color: task.completed
                                ? DarkGray
                                : darkMode
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 16),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CreateTaskWidget(
                                  task: task, // Pass the current task here
                                  onSubmit: (taskData) async {
                                    await taskDB.update(
                                        id: task.id,
                                        title: taskData["title"],
                                        description: taskData["description"],
                                        completed: taskData["completed"]);
                                    if (!mounted) return;
                                    fetchTodos();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () async {
                              await taskDB.delete(task.id);
                              fetchTodos();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateTaskWidget(onSubmit: (taskData) async {
                await taskDB.create(
                    title: taskData["title"]!,
                    description: taskData["description"]!);
                if (!mounted) return;
                fetchTodos();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }),
            );
          },
        ),
      );
}
