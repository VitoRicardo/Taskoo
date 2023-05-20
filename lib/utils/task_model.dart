class Task {
  final int? id;
  final String task;
  final int categoryID;
  String categoryName;
  bool status = false;
  Task(
      {required this.task,
      required this.categoryID,
      this.id,
      this.status = false,
      this.categoryName = 'category'});

  @override
  toString() {
    return "$task >$status< // id: $id // idCat: $categoryID ";
  }

  isSelected() => status = !status;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskName': task,
      'status': status ? 1 : 0,
      'idCategory': categoryID,
    };
  }
}
