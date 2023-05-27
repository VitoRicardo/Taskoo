import 'package:flutter/material.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/widgets/dotted_pop_up_button.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/database_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardCategory extends StatelessWidget {
  final Category category;

  CardCategory({Key? key, required this.category})
      : super(key: Key(category.category));

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
          key: const ValueKey(0),
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
                          child: CategoryEditModal(category: category),
                        );
                      });
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

class CategoryEditModal extends StatefulWidget {
  final Category category;

  const CategoryEditModal({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryEditModal> createState() => _CategoryEditModalState();
}

class _CategoryEditModalState extends State<CategoryEditModal> {
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 180,
      decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: TextField(
              maxLength: 15,
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
                hintText: 'Before: ${widget.category.category}',
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
          DottedPopUpButton(
              inputTextIsNotEmpty: _inputText.isNotEmpty,
              textButton: 'Edit Category',
              icon: const Icon(
                Icons.edit,
                color: AppColors.pink,
              ),
              onPress: () {
                if (_inputText.isNotEmpty) {
                  DB db = DB.instance;
                  widget.category.category = _inputText;
                  db.editCategory(widget.category);
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}
