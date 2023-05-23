import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/database_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardCategories extends StatelessWidget {
  final Category category;

  const CardCategories({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double tasksProportion = category.completeTasks / category.activeTasks;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: 200,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            )
          ],
          color: category.status ? Colors.greenAccent : AppColors.card,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          key: const ValueKey(1),
          direction: Axis.vertical,
          startActionPane: ActionPane(
            extentRatio: 1,
            motion: const ScrollMotion(),
            children: [
              CustomSlidableAction(
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                onPressed: (BuildContext context) {
                  final DB db = DB.instance;
                  db.deleteCategory(category);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.delete),
                    Text('Delete'),
                  ],
                ),
              ),
              CustomSlidableAction(
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                onPressed: (BuildContext context) {
                  print('EDTAR');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit),
                    Text('Edit'),
                  ],
                ),
              ),
            ],
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              DB db = DB.instance;
              db.selectCategory(category);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "${category.completeTasks}",
                          style: const TextStyle(color: AppColors.pink),
                        ),
                        TextSpan(text: " / ${category.activeTasks} tasks"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category.category,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 20,
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              backgroundColor: AppColors.secondaryText,
                              color: AppColors.pink,
                              minHeight: 4,
                              value: category.activeTasks != 0
                                  ? tasksProportion
                                  : 0.0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: category.activeTasks != 0
                              ? 180 * (tasksProportion) - 5
                              : 0,
                          bottom: 12,
                          child: Container(
                            width: 5,
                            height: tasksProportion != 1 &&
                                    category.activeTasks != 0
                                ? 5
                                : 0,
                            color: AppColors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
