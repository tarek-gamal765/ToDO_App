import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:get/get.dart';

class TaskController {
  RxList<Task> taskList = <Task>[].obs;

  Future<void> addTask(Task? task) async {
    await DBHelper.insert(task!);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> list = await DBHelper.query();
    taskList.assignAll(list.map((data) => Task.fromJson(data)).toList());
  }

  Future<void> deleteTask(Task? task) async {
    await DBHelper.deleteTask(task!);
    getTasks();
  }
  Future<void> deleteAllTasks() async {
    await DBHelper.deleteAllTasks();
    getTasks();
  }

  Future<void> update(int? id) async {
    await DBHelper.update(id!);
    getTasks();
  }
}
