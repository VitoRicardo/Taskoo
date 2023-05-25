import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'widgets/category/add_category.dart';
import 'widgets/task/add_task.dart';
import 'widgets/category/list_view_categories.dart';
import 'widgets/task/list_view_tasks.dart';
import 'utils/controller.dart';
import 'widgets/task/delete_done_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskoo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Controller controller = Controller.instance;

    /// Segmento de código que só deve ser usado apenas uma vez por aplicação para fins de testes
    // DB db = DB.instance;
    // int indexCategory = 0;
    // categoryTask.forEach(
    //   (category, taskList) {
    //     indexCategory++;
    //     db.insertCategory(Category(category: category));
    //
    //     for (String task in taskList) {
    //       Task tarefa = Task(task: task, categoryID: indexCategory);
    //       db.insertTask(tarefa);
    //     }
    //   },
    // );

    ///

    controller.updateCategoryList();
    controller.updateTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's Smash yours obstacles",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "CATEGORIES",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.bold),
                  ),
                  AddCategory()
                ],
              ),
              const SizedBox(
                height: 100,
                width: double.infinity,
                child: ListViewCategories(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Text(
                      "TASKS",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DeleteDoneTask(),
                  SizedBox(width: 10),
                  AddTask()
                ],
              ),
              const SizedBox(
                height: 300,
                child: ListViewTask(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
