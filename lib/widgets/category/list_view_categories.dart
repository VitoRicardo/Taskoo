import 'package:flutter/material.dart';
import 'package:taskoo/utils/controller.dart';
import 'package:taskoo/utils/database_model.dart';
import 'card_category.dart';

class ListViewCategories extends StatefulWidget {
  const ListViewCategories({Key? key}) : super(key: key);

  @override
  State<ListViewCategories> createState() => _ListViewCategoriesState();
}

class _ListViewCategoriesState extends State<ListViewCategories> {
  final DB db = DB.instance;
  final Controller controller = Controller.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return CardCategories(
              category: controller.categories[index],
            );
          },
        );
      },
    );
  }
}
