import 'package:flutter/material.dart';
import 'package:tasks_app/constants/colors.dart';
import 'package:tasks_app/model/task.dart';

class CreateTaskWidget extends StatefulWidget {
  final Task? task;
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const CreateTaskWidget({
    super.key,
    this.task,
    required this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKEY = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final isCompleted = widget.task?.completed ?? false;

    return AlertDialog(
      title: Text(isEditing ? "Editing Task" : "Add Task"),
      content: SizedBox(
        width: 300, // Set the desired width
        child: Form(
          key: formKEY,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: AccentColor, fontSize: 20),
                  hintText: "Type your task title here",
                ),
                validator: (value) =>
                    value != null && value.isEmpty ? "Title is required" : null,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: AccentColor, fontSize: 20),
                      hintText: "Type your task description here",
                    ),
                    maxLines: null, // Allow unlimited lines
                    keyboardType:
                        TextInputType.multiline, // Enable multiline input
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: isEditing ? const Text("Edit") : const Text("Add"),
          onPressed: () {
            if (formKEY.currentState != null &&
                formKEY.currentState!.validate()) {

              widget.onSubmit({
                'title': titleController.text,
                'description': descriptionController.text,
                'edited': isEditing,
                'completed': isCompleted,
              });
            }
          },
        ),
      ],
    );
  }
}