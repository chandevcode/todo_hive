import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_hive/constants/colors.dart';
import 'package:todo_hive/db/controllers/task_db_controller.dart';
import 'package:todo_hive/services/common_parameters.dart';
import 'package:todo_hive/widgets/task_tile.dart';

import '../controllers/create_task.dart';
import '../db/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Task'),
        centerTitle: true,
        backgroundColor: primaryColor,
        bottom: TabBar(controller: _tabController, tabs: [
          tabText('Pending'),
          tabText('Starred'),
          tabText('Completed'),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreenBody(listenable: pendingTaskListNotifier),
          HomeScreenBody(listenable: starredTaskListNotifier),
          HomeScreenBody(listenable: completedTaskListNotifier),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedDate = DateTime.now();
          selectedCategory = null;
          createTask(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}

Widget tabText(String tabName) {
  return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        tabName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
}

class HomeScreenBody extends StatelessWidget {
  final ValueListenable<List<TaskModel>> listenable;
  const HomeScreenBody({Key? key, required this.listenable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (BuildContext ctx, List<TaskModel> taskList, _) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(task: taskList[index]);
          },
          itemCount: taskList.length,
        );
      },
    );
  }
}
