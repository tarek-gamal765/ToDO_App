import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? database;
  static const String _tableName = 'tasks';

  static Future<void> init() async {
    if (database == null) {
      String path = await getDatabasesPath() + 'task.db';
    database =  await openDatabase(
        path,
        version: 1,
        onCreate: (database, version) async {
          await database.execute(
              'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, title TEXT, note TEXT, date TEXT, startTime TEXT, endTime TEXT, repeat TEXT, remind TEXT, isCompleted INTEGER, color INTEGER)');
        },
      );
    }
  }
  static Future<int> insert(Task? task)async {
    return await database!.insert(_tableName, task!.toJson());
  }

  static Future<int> deleteTask(Task? task) async{
    return await database!.delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }
  static Future deleteAllTasks( ) async{
    return await database!.delete(_tableName);
  }

  static Future<int> update(int id) async{
    return await database!.rawUpdate(
        'UPDATE $_tableName SET isCompleted = ? WHERE id = ?',
        [1,id]);
  }
  static Future<List<Map<String, dynamic>>> query() async{
    return await database!.query(_tableName);
  }
}
