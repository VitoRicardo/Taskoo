import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/database_model.dart';

//TODO: Create a PopUp alerting the user that he is trying to delete all marked items

class DeleteDoneTask extends StatelessWidget {
  const DeleteDoneTask({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.card,
        ),
        width: 70,
        height: 40,
        child: TextButton(
          style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.zero),
          onPressed: () {
            final DB db = DB.instance;
            db.deleteAllTaskDone();
          },
          child: const Icon(
            Icons.restore_from_trash_sharp,
            color: AppColors.pink,
          ),
        ),
      ),
    );
  }
}
