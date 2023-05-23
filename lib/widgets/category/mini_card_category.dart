import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/database_model.dart';

class MiniCardCategory extends StatelessWidget {
  final Category category;

  const MiniCardCategory({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
          clipBehavior: Clip.antiAlias,
          width: 120,
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
          child: Center(
            child: TextButton(
              onPressed: () {
                DB db = DB.instance;
                db.selectCategory(category);
              },
              child: Text(
                category.category,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black),
              ),
            ),
          )),
    );
  }
}
