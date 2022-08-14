import 'package:flutter/cupertino.dart';
import 'package:pomodoro/providers/task.dart';

class HandleTasks with ChangeNotifier {
  List<Task> _items = [];
  List<Task> get items => [..._items];

  void addTask(Task task) {
    _items.add(task);
    if(_items.length > 1) {
      for (int i = 0;i < _items.length - 1;i++){
        for (int j = i+1;j < _items.length;j++){
          if (_items.elementAt(i).id == _items.elementAt(j).id) {
            _items.remove(_items.elementAt(j));
          }
        }
      }
    }
    notifyListeners();
  }

  void editTask(Task task) {
    int currentTask = _items.indexWhere((element) => element.id == task.id);
    // _items.removeAt(currentTask);
    print(currentTask.toString());
    _items.insert(currentTask, task);
    notifyListeners();
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
