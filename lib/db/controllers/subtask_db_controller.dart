import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/db/controllers/task_db_controller.dart';
import 'package:todo_hive/db/models/subtask_model.dart';

import '../models/task_model.dart';

ValueNotifier<List<SubTaskModel>> subTaskListNotifier = ValueNotifier([]);

Future addSubTask(TaskModel task, SubTaskModel subTask) async {
  final subTaskDB = await Hive.openBox<SubTaskModel>('${task.id}');
  final id = await subTaskDB.add(subTask);
  subTask.id = id;
  subTaskDB.put(subTask.id, subTask);
  subTaskListNotifier.value.add(subTask);
  refreshUI();
}

Future<void> updateSubTask(
    TaskModel task, SubTaskModel subTask, bool value) async {
  final subTaskDB = await Hive.openBox<SubTaskModel>('${task.id}');
  await subTaskDB.put(subTask.id, subTask);
  if (subTaskDB.values.any((e) => e.isCompleted == false)) {
  } else {
    task.isCompleted = true;
    updateTask(task);
  }
}

Future<void> deleteSubTask(TaskModel task, int id) async {
  final subTaskDB = await Hive.openBox<SubTaskModel>('${task.id}');
  await subTaskDB.delete(id);
  getAllSubTask(task);
  if (subTaskDB.values.any((e) => e.isCompleted == false)) {
  } else {
    task.isCompleted = true;
    updateTask(task);
  }
}

Future<void> getAllSubTask(TaskModel task) async {
  final subTaskDB = await Hive.openBox<SubTaskModel>('${task.id}');
  subTaskListNotifier.value.clear();
  subTaskListNotifier.value.addAll(subTaskDB.values);
  refreshUI();
}

refreshUI() {
  subTaskListNotifier.notifyListeners();
}
