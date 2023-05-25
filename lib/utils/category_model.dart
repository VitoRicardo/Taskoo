class Category {
  final int? id;
  final String category;
  bool status;
  int activeTasks;
  int completeTasks;
  Category(
      {this.id,
      required this.category,
      this.status = false,
      this.activeTasks = 0,
      this.completeTasks = 0});

  @override
  toString() {
    return "\n{ id:$id >> $category // isSelected: $status // ActiveTasks: $activeTasks // CompleteTasks: $completeTasks } ";
  }

  isSelected() => status = !status;

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'status': status ? 1 : 0,
    };
  }
}
