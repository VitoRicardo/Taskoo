import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/widgets/category/mini_card_category.dart';
import 'package:taskoo/widgets/dotted_pop_up_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskoo/utils/task_model.dart';
import 'package:taskoo/utils/controller.dart';
import 'package:taskoo/utils/database_model.dart';

class CardTask extends StatefulWidget {
  final Task task;
  CardTask({Key? key, required this.task}) : super(key: Key(task.task));

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(3, 3),
          )
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.card, AppColors.shadow],
        ),
      ),
      child: Slidable(
        key: const ValueKey(1),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (BuildContext context) {
                final DB db = DB.instance;
                db.deleteTask(widget.task);
              },
            ),
            SlidableAction(
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              onPressed: (BuildContext context) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                          top: Radius.circular(10))),
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TaskEditModal(
                        task: widget.task,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.3,
              child: Checkbox(
                activeColor: AppColors.pink,
                focusColor: AppColors.pink,
                value: widget.task.status,
                side: const BorderSide(color: AppColors.pink, width: 2),
                onChanged: (value) {
                  final DB db = DB.instance;
                  setState(() {
                    widget.task.status = !widget.task.status;
                    db.checkTask(widget.task);
                  });
                },
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: SizedBox(
                    width: 240,
                    child: Text(
                      widget.task.task,
                      style: TextStyle(
                        color: Colors.black87,
                        decoration: widget.task.status
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.task.categoryName,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskEditModal extends StatefulWidget {
  final Task task;

  const TaskEditModal({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskEditModal> createState() => _TaskEditModalState();
}

class _TaskEditModalState extends State<TaskEditModal> {
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
          const Text(
            'Edit Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.pink,
                    width: 2,
                  ),
                ),
                hintText: 'Before: ${widget.task.task}',
                hintStyle: const TextStyle(
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
                  DottedPopUpButton(
                    inputTextIsNotEmpty:
                        _inputText.isNotEmpty || controller.anyCategorySelected,
                    textButton: 'Edit Task',
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.pink,
                    ),
                    onPress: () {
                      DB db = DB.instance;
                      _inputText.isNotEmpty
                          ? widget.task.task = _inputText
                          : null;
                      controller.anyCategorySelected
                          ? widget.task.categoryID =
                              controller.categorySelected!.id!
                          : null;

                      db.editTask(widget.task);
                      Navigator.pop(context);
                    },
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
