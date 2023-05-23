import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/task_model.dart';
import 'package:taskoo/utils/database_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardTask extends StatefulWidget {
  final Task task;

  const CardTask({Key? key, required this.task}) : super(key: key);

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
              onPressed: (BuildContext context) {
                final DB db = DB.instance;
                db.deleteTask(widget.task);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (BuildContext context) {},
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
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
