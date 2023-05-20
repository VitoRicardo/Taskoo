import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/controller.dart';

//TODO: Create a PopUp alerting the user that he is trying to delete all marked items
//TODO: Make the animations look smooth "Bouncing animation"

class DeleteDoneTask extends StatelessWidget {
  const DeleteDoneTask({super.key});

  @override
  Widget build(BuildContext context) {
    Controller controller = Controller.instance;
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
            // controller.deleteDone();
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
