import 'package:flutter/cupertino.dart';
import 'package:pomodoro/providers/task.dart';

class HandleTasks with ChangeNotifier {
  List<Task> _items = [];
  List<Task> get items => [..._items];

  void addTask(Task task) {
    _items.add(task);
    notifyListeners();
  }

  void editTask(Task task) {
    int currentTask = _items.indexWhere((element) => element.id == task.id);
    _items.insert(currentTask, task);
  }

  void updateTask(Task task) {
    task.isDone = !task.isDone!;
    notifyListeners();
  }

  void removeTask(Task task) {
    _items.removeWhere((element) => element.id == task.id);
    notifyListeners();
  }
}
