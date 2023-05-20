import 'package:flutter/material.dart';
import 'package:taskoo/utils/database_model.dart';
import 'package:taskoo/utils/controller.dart';
import 'card_task.dart';

class ListViewTask extends StatefulWidget {
  const ListViewTask({Key? key}) : super(key: key);

  @override
  State<ListViewTask> createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask> {
  Controller controller = Controller.instance;
  DB db = DB.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return ListView.separated(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
            itemCount: controller.tasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (BuildContext context, int index) {
              return CardTask(task: controller.tasks[index]);
            },
          );
        });
  }
}
