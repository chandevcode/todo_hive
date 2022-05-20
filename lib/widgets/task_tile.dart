import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_hive/constants/colors.dart';

import '../db/controllers/task_db_controller.dart';
import '../db/models/task_model.dart';
import '../screens/task_screen.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TaskScreen(task: task)));
      },
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        // ignore: sort_child_properties_last
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.shade500)
              ],
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            Expanded(
              child: CircleAvatar(
                radius: 30,
                child: Text(
                  "${task.date.day}/${task.date.month}",
                  style: const TextStyle(
                      color: backgroundColor, fontWeight: FontWeight.bold),
                ),
                backgroundColor: primaryColor,
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.bottomLeft,
                    child: TaskTileText(
                        text: task.title,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.bottomLeft,
                    child: TaskTileText(text: task.category, color: textColor),
                  ))
                ],
              ),
            )
          ]),
        ),
        actions: !task.isCompleted
            ? [
                TaskTileActions(
                    color: Colors.lightGreen,
                    icon: task.isCompleted
                        ? Icons.remove_done_rounded
                        : Icons.checklist_rtl_sharp,
                    onTap: () {
                      task.isCompleted = true;
                      updateTask(task);
                    }),
                TaskTileActions(
                    color: Colors.lightBlue.shade100,
                    icon: task.isStarred ? Icons.star : Icons.star_border,
                    onTap: () {
                      task.isStarred = !task.isStarred;
                      updateTask(task);
                    })
              ]
            : [],
        secondaryActions: [
          TaskTileActions(
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                if (task.id == null) {
                } else {
                  deleteTask(task.id!);
                }
              })
        ],
      ),
    );
  }
}

class TaskTileActions extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function() onTap;
  const TaskTileActions(
      {Key? key, required this.color, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, boxShadow: [
          BoxShadow(blurRadius: 2, color: Colors.grey.shade500),
        ]),
        child: Icon(
          icon,
          color: backgroundColor,
        ),
      ),
      onTap: onTap,
    );
  }
}

class TaskTileText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const TaskTileText(
      {Key? key,
      required this.text,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
