import 'package:sqflite/sqflite.dart';
import 'package:taskoo/utils/category_model.dart';
import 'package:taskoo/utils/controller.dart';
import 'package:taskoo/utils/task_model.dart';

class DB {
  //Construtor com acesso privado
  DB._();
  //Criar uma instância de DB
  static final DB instance = DB._();
  //Instância do SQLite
  static Database? _database;

  get database async {
    return _database ?? await _initDatabase();
  }

  static const tableCategory = 'category';
  static const columnId = 'id';
  static const columnCategory = 'category';
  static const columnCategoryStatus = 'status';

  static const tableTask = 'task';
  static const columnTaskId = 'id';
  static const columnTask = 'taskName';
  static const columnCategoryId = 'idCategory';
  static const columnTaskStatus = 'status';

  _initDatabase() async {
    return await openDatabase(
      '${await getDatabasesPath()}task.db',
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_category);
    await db.execute(_task);
  }

  String get _category => '''
  CREATE TABLE $tableCategory(
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $columnCategory VARCHAR(30) NOT NULL,
  $columnCategoryStatus INTEGER NOT NULL 
  )
  ''';
  String get _task => '''
  CREATE TABLE $tableTask(
  $columnTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
  $columnTask VARCHAR(110) NOT NULL,
  $columnCategoryId INTEGER NOT NULL,
  $columnTaskStatus INTEGER NOT NULL,
  FOREIGN KEY($columnCategoryId) REFERENCES $tableCategory($columnId) ON DELETE CASCADE
  )
  ''';

  Future<void> insertCategory(Category category) async {
    final Database db = await database;
    final Controller controller = Controller.instance;
    await db.insert(
      tableCategory,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    controller.updateCategoryList();
  }

  Future<void> insertTask(Task task) async {
    final Database db = await database;
    final Controller controller = Controller.instance;
    await db.insert(
      tableTask,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    controller.updateCategoryList();
    controller.updateTaskList();
  }

  /// Debug Function
  Future<void> printTasks() async {
    final db = await database;
    final tasks = await db.query(tableTask);
    print('Tasks:');
    tasks.forEach((task) {
      print('ID: ${task[columnTaskId]}');
      print('Name: ${task[columnTask]}');
      print('Category ID: ${task[columnCategoryId]}');
      print('Status: ${task[columnTaskStatus]}');
      print('------------------');
    });
  }

  Future<void> printCategory() async {
    final db = await database;
    final categories = await db.query(tableCategory);
    print('Category:');
    categories.forEach((category) {
      print('ID: ${category[columnId]}');
      print('Category: ${category[columnCategory]}');
      print('Status: ${category[columnCategoryStatus]}');
      print('------------------');
    });
  }

  ///

  Future<List<Category>> getAllCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT c.$columnId , c.$columnCategory, c.$columnCategoryStatus,
    COUNT(t.$columnCategoryId) as "Active Tasks",
    SUM(CASE WHEN t.$columnTaskStatus = 1 THEN 1 ELSE 0 END) as "Complete Tasks"
    FROM $tableCategory as c
    LEFT JOIN $tableTask as t ON c.$columnId = t.$columnCategoryId
    GROUP BY c.$columnCategory
    ORDER BY c.$columnId desc
    ''');
    return List.generate(
      maps.length,
      (i) => Category(
        id: maps[i][columnId],
        category: maps[i][columnCategory],
        status: maps[i][columnCategoryStatus] == 1,
        activeTasks: maps[i]["Active Tasks"],
        completeTasks: maps[i]["Complete Tasks"],
      ),
    );
  }

  Future<List<Task>> getTasksFromCategory() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps;
    maps = await db.rawQuery('''
    SELECT $tableTask.$columnTaskId AS TaskID, $tableTask.$columnTask, $tableTask.$columnTaskStatus,
    $tableCategory.$columnId, $tableCategory.$columnCategory
    FROM $tableTask 
    INNER JOIN $tableCategory ON $tableCategory.$columnId = $tableTask.$columnCategoryId
    WHERE 
        CASE 
          WHEN 
              (SELECT COUNT(*) FROM $tableCategory WHERE $columnCategoryStatus = 0) <> 
              (SELECT COUNT(*) FROM $tableCategory) THEN $tableCategory.$columnCategoryStatus = 1
              ELSE Category.status = 0
          END
        ORDER BY $tableTask.$columnId desc;
    ''');
    return List.generate(
      maps.length,
      (i) => Task(
          id: maps[i]['TaskID'],
          task: maps[i][columnTask],
          status: maps[i][columnTaskStatus] == 1,
          categoryID: maps[i][columnId],
          categoryName: maps[i][columnCategory]),
    );
  }

  Future<void> selectCategory(Category category) async {
    final Controller controller = Controller.instance;
    final Database db = await database;
    await db.rawQuery(''' 
    UPDATE $tableCategory SET status = CASE
    WHEN $columnId = ${category.id} AND $columnCategoryStatus = 0
    THEN 1
    ELSE 0
    END;''');
    controller.updateCategoryList();
    controller.updateTaskList();
  }

  Future<void> checkTask(Task task) async {
    final Database db = await database;
    final Controller controller = Controller.instance;
    await db.rawQuery('''
    UPDATE $tableTask
    SET $columnTaskStatus = ${task.status ? 1 : 0}
    WHERE $columnTaskId = ${task.id}
    ''');
    controller.updateCategoryList();
  }

  Future<void> editCategory(Category category) async {
    final Database db = await database;
    final Controller controller = Controller.instance;

    // final List<Map<String, dynamic>> maps;
    // maps = await db.rawQuery('''UPDATE $tableCategory SET status = CASE
    // WHEN $columnId = ${category.id} THEN 1
    // ELSE 0
    // END;
    // ''');

    // maps = await db.rawQuery('''SELECT Task.*
    // FROM $tableTask
    // LEFT JOIN $tableCategory ON $tableTask.$columnCategoryId = $tableCategory.$columnId
    // WHERE $tableCategory.$columnCategoryStatus = 1
    //   OR (NOT EXISTS (SELECT 1 FROM $tableCategory WHERE $columnCategoryStatus = 1)
    //   AND $tableCategory.$columnCategoryStatus = 0);''');

    await db.update(
      tableCategory,
      category.toMap(),
      where: '$columnId == ?',
      whereArgs: [category.id],
    );
    // call update in ChangeNotifier Controller
    controller.updateCategoryList();
  }

  Future<void> editTask(Task task) async {
    final Database db = await database;
    final Controller controller = Controller.instance;
    await db.update(
      tableTask,
      task.toMap(),
      where: '$columnTaskId == ?',
      whereArgs: [task.id],
    );
    controller.updateTaskList();
  }

  Future<void> deleteCategory(Category category) async {
    final Database db = await database;
    await db.delete(
      tableCategory,
      where: '$columnId == ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteTask(Task task) async {
    final Database db = await database;
    await db.delete(
      tableTask,
      where: '$columnTaskId == ?',
      whereArgs: [task.id],
    );
  }

  Future<void> clearCategorySelected() async {
    final Database db = await database;
    final Controller controller = Controller.instance;
    await db
        .rawQuery('''UPDATE $tableCategory SET $columnCategoryStatus = 0''');

    // call update in ChangeNotifier Controller
    controller.updateCategoryList();
  }
}
