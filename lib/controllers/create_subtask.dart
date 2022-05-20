import 'package:flutter/material.dart';
import 'package:todo_hive/constants/colors.dart';
import 'package:todo_hive/controllers/create_task.dart';
import 'package:todo_hive/db/controllers/subtask_db_controller.dart';
import 'package:todo_hive/db/models/subtask_model.dart';
import 'package:todo_hive/db/models/task_model.dart';

void createSubTask(BuildContext context, TaskModel task) {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    'Add Subtask',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      return value!.trim().isNotEmpty
                          ? null
                          : 'Enter a task title';
                    },
                    onFieldSubmitted: (_) {
                      formKey.currentState!.validate();
                    },
                    decoration: InputDecoration(
                        hintText: 'title',
                        enabledBorder: customBorder(primaryColor),
                        focusedBorder: customBorder(Colors.black),
                        errorBorder: customBorder(Colors.red),
                        focusedErrorBorder: customBorder(Colors.red)),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                    controller: _detailController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      enabledBorder: customBorder(primaryColor),
                      focusedBorder: customBorder(Colors.black),
                      errorBorder: customBorder(Colors.red),
                      focusedErrorBorder: customBorder(Colors.red),
                    )),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        SubTaskModel subTask = SubTaskModel(
                            title: _titleController.text,
                            detail: _detailController.text,
                            isCompleted: false);

                        addSubTask(task, subTask);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          fontSize: 16,
                          color: backgroundColor,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
        });
      });
}

InputBorder customBorder(Color color) {
  return OutlineInputBorder(borderSide: BorderSide(color: color, width: 2));
}
