import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskoo/widgets/dotted_pop_up_button.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/database_model.dart';

class AddCategory extends StatelessWidget {
  const AddCategory({
    Key? key,
  }) : super(key: key);

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
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
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
                    child: const CategoryAddModal(),
                  );
                });
          },
        ),
      ),
    );
  }
}

class CategoryAddModal extends StatefulWidget {
  const CategoryAddModal({Key? key}) : super(key: key);

  @override
  State<CategoryAddModal> createState() => _CategoryAddModalState();
}

class _CategoryAddModalState extends State<CategoryAddModal> {
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
            'Add Category',
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
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.pink,
                    width: 2,
                  ),
                ),
                hintText: "Ex: Mental Health",
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
          DottedPopUpButton(
            inputTextIsNotEmpty: _inputText.isNotEmpty,
            textButton: 'Create a Category',
            icon: const Icon(
              Icons.add,
              color: AppColors.pink,
            ),
            onPress: () {
              if (_inputText.isNotEmpty) {
                DB db = DB.instance;
                db.insertCategory(Category(category: _inputText));
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
