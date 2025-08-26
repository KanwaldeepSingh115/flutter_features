import 'package:flutter/material.dart';
import 'package:flutter_practice/Sqflite/sqflite_helper.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final SqfliteHelper helper = SqfliteHelper();

  final TextEditingController taskController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allTasks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    taskController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await helper.getTasks();
    setState(() {
      allTasks = tasks;
    });
  }

  List<Map<String, dynamic>> get filteredTasks {
    return allTasks.where((task) {
      final title = task['title'].toString().toLowerCase();
      return title.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? const Center(child: Text('No tasks found.'))
                    : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final isChecked = task['status'] == 1;

                        return ListTile(
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (value) async {
                              await helper.updateTask(task['id'], value!);
                              await _loadTasks();
                            },
                          ),
                          title: Text(task['title']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    isChecked
                                        ? () {
                                          taskController.text = task['title'];
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  title: const Text(
                                                    'Edit Task Title',
                                                  ),
                                                  content: TextField(
                                                    controller: taskController,
                                                    autofocus: true,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText:
                                                              'Enter new title',
                                                        ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        final newTitle =
                                                            taskController.text
                                                                .trim();
                                                        if (newTitle
                                                            .isNotEmpty) {
                                                          await helper
                                                              .updateTaskTitle(
                                                                task['id'],
                                                                newTitle,
                                                              );
                                                          taskController
                                                              .clear();
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          await _loadTasks();
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Update',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                        : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    isChecked
                                        ? () async {
                                          await helper.deleteTask(task['id']);
                                          await _loadTasks();
                                        }
                                        : null,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Add Task'),
                  content: TextField(
                    controller: taskController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Enter title'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final title = taskController.text.trim();
                        if (title.isNotEmpty) {
                          await helper.insertTasks(title, false);
                          taskController.clear();
                          Navigator.pop(context);
                          await _loadTasks();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
