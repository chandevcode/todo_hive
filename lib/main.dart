import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/db/models/subtask_model.dart';
import 'package:todo_hive/db/models/task_model.dart';
import 'package:todo_hive/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }

  if (!Hive.isAdapterRegistered(SubTaskModelAdapter().typeId)) {
    Hive.registerAdapter(SubTaskModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo Hive',
      home: HomeScreen(),
    );
  }
}
