import '../db/models/task_model.dart';

sortTask(List<TaskModel> task) {
  task.sort((a, b) => a.date.compareTo(b.date));
}
