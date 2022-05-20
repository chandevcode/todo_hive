import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_hive/constants/colors.dart';
import 'package:todo_hive/controllers/create_subtask.dart';
import 'package:todo_hive/db/controllers/subtask_db_controller.dart';
import 'package:todo_hive/db/controllers/task_db_controller.dart';
import 'package:todo_hive/db/models/subtask_model.dart';
import 'package:todo_hive/db/models/task_model.dart';

class TaskScreen extends StatelessWidget {
  final TaskModel task;
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getAllTask();
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        " ${task.category}",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        " ${DateFormat('dd-MM-yyyy')}",
                        style: const TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ))
                  ],
                ),
                SizedBox(
                    width: 100,
                    height: 80,
                    child: !task.isCompleted
                        ? TextButton(
                            onPressed: () {
                              createSubTask(context, task);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                                Text(
                                  'Add Subtasks',
                                  style: TextStyle(fontSize: 13),
                                )
                              ],
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Completed',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                          ))
              ],
            ),
          ),
          Flexible(
              child: ValueListenableBuilder(
            valueListenable: subTaskListNotifier,
            builder: (BuildContext ctx, List<SubTaskModel> taskList, _) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final subTask = taskList[index];
                  return SubTaskTile(subTask: subTask, task: task);
                },
                itemCount: taskList.length,
              );
            },
          ))
        ],
      ),
    );
  }
}

class SubTaskTile extends StatefulWidget {
  final TaskModel task;
  final SubTaskModel subTask;
  const SubTaskTile({Key? key, required this.task, required this.subTask})
      : super(key: key);

  @override
  State<SubTaskTile> createState() => _SubTaskTileState();
}

class _SubTaskTileState extends State<SubTaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: widget.task.isCompleted || widget.subTask.isCompleted
                  ? Colors.green
                  : primaryColor)),
      child: ListTile(
        leading: Checkbox(
          value: widget.task.isCompleted || widget.subTask.isCompleted,
          onChanged: (value) {
            setState(() {
              widget.subTask.isCompleted = value!;
            });
            if (widget.task.isCompleted) {
              widget.task.isCompleted = false;
              updateTask(widget.task);
            }
            updateSubTask(widget.task, widget.subTask, value!);
          },
        ),
        title: Text(
          widget.subTask.title,
          style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: widget.task.isCompleted || widget.subTask.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
              decorationColor: Colors.green,
              decorationThickness: 2),
        ),
        subtitle: widget.subTask.detail != null
            ? Text(
                widget.subTask.detail!,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  decoration:
                      widget.task.isCompleted || widget.subTask.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                ),
              )
            : null,
        trailing: IconButton(
          onPressed: () {
            if (widget.subTask.id != null) {
              deleteSubTask(widget.task, widget.subTask.id!);
            }
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
