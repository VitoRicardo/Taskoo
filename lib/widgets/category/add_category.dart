import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskoo/utils/app_colors.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/controller.dart';
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
      height: 180,
      decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tasks
          const Text(
            'Add Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          /// TextField
          //TODO: TextField com alerta de Span.lenght == 0
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

          /// Add Button
          AddDottedButton(inputText: _inputText)
        ],
      ),
    );
  }
}

class AddDottedButton extends StatefulWidget {
  final String inputText;
  const AddDottedButton({Key? key, required this.inputText}) : super(key: key);

  @override
  State<AddDottedButton> createState() => _AddDottedButtonState();
}

class _AddDottedButtonState extends State<AddDottedButton> {
  Controller controller = Controller.instance;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
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
          child: widget.inputText.isNotEmpty
              ? const Icon(
                  Icons.add,
                  color: AppColors.pink,
                )
              : const Text('Create a Category'),
          onPressed: () {
            if (widget.inputText.isNotEmpty) {
              //TODO: As categorias para serem adicionadas devem conter no máximo 15
              Controller controller = Controller.instance;
              DB db = DB.instance;
              int index = controller.categories.length;
              db.insertCategory(
                  Category(id: index + 1, category: widget.inputText));
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
