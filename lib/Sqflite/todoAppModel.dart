import 'package:flutter_practice/Sqflite/sqflite_helper.dart';

class Task {
  late final int? id;
  late final String? title;
  bool? status;

  Task({this.id, this.title, this.status});

  final helper = SqfliteHelper();

  List<Task> tasks = [];

  createTask(Task task) async {
    await helper.insertTasks(task.title!, task.status!);
    tasks.clear();
    await helper.getTasks();
  }

  deleteTask(Task task) async {
    final index = tasks.indexOf(task);
    tasks.removeAt(index);
    await helper.deleteTask(task.id!);
  }

  toggleTask(Task task) async {
    final index = tasks.indexOf(task);
    tasks[index].status = !tasks[index].status!;
    await helper.updateTask(task.id!, task.status!);
  }

  getTasks() async {
    for (var item in await helper.getTasks()) {
      tasks.add(fromMap(item));
    }
  }

  Task fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'], title: map['title'], status: map['status']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'status': status};
  }
}
