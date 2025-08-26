import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqfliteHelper {
  Future<Database> openmyDatabase() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath =
        Platform.isAndroid || Platform.isIOS
            ? await getDatabasesPath()
            : await databaseFactory.getDatabasesPath();

    final path = join(dbPath, 'myDb.db');

    print(path);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) {
          db.execute(
            'CREATE TABLE todoList(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
            'title TEXT,'
            'status INTEGER)',
          );
        },
      ),
    );
  }

  Future<void> insertTasks(String title, bool status) async {
    final db = await openmyDatabase();

    db.insert('todoList', {
      'title': title,
      'status': status ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask(int id) async {
    final db = await openmyDatabase();
    db.delete('todoList', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(int id, bool status) async {
    final db = await openmyDatabase();
    db.update(
      'todoList',
      {'status': status ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await openmyDatabase();
    return await db.query('todoList');
  }

  Future<void> updateTaskTitle(int id, String newTitle) async {
    final db = await openmyDatabase();
    await db.update(
      'todoList',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
