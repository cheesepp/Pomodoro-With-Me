import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:pomodoro/providers/handle_tasks.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../providers/task.dart';
import '../widgets/tasks_list.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);
  static const routeName = '/tasks-screen';
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _addTask(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Add Task',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        autofocus: true,
                        controller: titleController,
                        decoration: const InputDecoration(
                            label: Text('Title'), border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        autofocus: true,
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            label: Text('Description'),
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('cancel'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                var task = Task(
                                    description: descriptionController.text,
                                    title: titleController.text,
                                    date: DateTime.now().toString(),
                                    id: Uuid().v1());
                                context.read<HandleTasks>().addTask(task);
                                Navigator.pop(context);
                              },
                              child: const Text('Add'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<HandleTasks>(context).items;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Lottie.network(
                      'https://assets3.lottiefiles.com/private_files/lf30_gdvhysw2.json',
                      fit: BoxFit.cover),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Todo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            Center(
              child: Chip(
                label: Text(
                  '${todoList.length} Pending',
                ),
              ),
            ),
            TaskList(taskList: todoList)
          ],
        ),
      ),
    );
  }
}
