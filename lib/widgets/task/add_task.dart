import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/controller.dart';
import 'package:taskoo/utils/task_model.dart';
import 'package:taskoo/utils/database_model.dart';
import 'package:taskoo/widgets/category/mini_card_category.dart';

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 40,
        width: 70,
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Icon(
            Icons.add,
            color: AppColors.pink,
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10), top: Radius.circular(10))),
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const TaskAddModal(),
                  );
                });
          },
        ),
      ),
    );
  }
}

class TaskAddModal extends StatefulWidget {
  const TaskAddModal({Key? key}) : super(key: key);

  @override
  State<TaskAddModal> createState() => _TaskAddModalState();
}

class _TaskAddModalState extends State<TaskAddModal> {
  String _inputText = '';
  Controller controller = Controller.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 220,
      decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tasks
          const Text(
            'Add Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          /// TextField
          SizedBox(
            height: 50,
            width: double.infinity,
            child: TextField(
              maxLength: 100,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _inputText = value;
                });
              },
              cursorColor: AppColors.pink,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.pink,
                    width: 2,
                  ),
                ),
                hintText: "Ex: Meet with Jaine at 13:00",
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                ),
              ),
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          /// ListView Horizontal of Categories
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Column(
                children: [
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return MiniCardCategory(
                            category: controller.categories[index]);
                      },
                    ),
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.anyCategorySelected
                            ? const Icon(
                                Icons.add,
                                color: AppColors.pink,
                              )
                            : const Text('Select a Category'),
                        onPressed: () {
                          DB db = DB.instance;
                          Controller controller = Controller.instance;
                          if (controller.anyCategorySelected &&
                              _inputText.isNotEmpty) {
                            db.insertTask(
                              Task(
                                  task: _inputText,
                                  categoryID: controller.categorySelected!.id),
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
