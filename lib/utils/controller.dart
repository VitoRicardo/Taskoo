import 'package:flutter/cupertino.dart';
import 'task_model.dart';
import 'category_model.dart';
import 'database_model.dart';

class Controller extends ChangeNotifier {
  Controller._();
  static final Controller instance = Controller._();
  DB db = DB.instance;

  List<Task> _tasks = [];
  List<Category> _categories = [];
  bool anyCategorySelected = false;
  Category? categorySelected;

  List<Task> get tasks => _tasks;
  List<Category> get categories => _categories;

  void updateTaskList() async {
    _tasks = await db.getTasksFromCategory();
    notifyListeners();
  }

  void updateCategoryList() async {
    db.printCategory();
    _categories = await db.getAllCategories();
    anyCategorySelected = _categories.any((instance) => instance.status);
    if (anyCategorySelected) {
      categorySelected = _categories.firstWhere((instance) => instance.status);
    }
    notifyListeners();
  }
}

/// Nenhuma Categoria estava selecionada e Cat1 foi selecionada  >> anyCategorySelected = true // categorySelected = Cat1
/// Cat1 estava selecionada e foi novamente selecionada >> anyCategorySelected = false // categorySelected = NULL
/// Cat1 estava selecionada e Cat2 foi  selecionada >> anyCategorySelected = true // categorySelected = Cat2
