import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/providers/handle_tasks.dart';
import 'package:pomodoro/services/firebase_services.dart';
import 'package:provider/provider.dart';
import '../providers/task.dart';

class TaskTile extends StatefulWidget {
  TaskTile({Key? key, required this.task}) : super(key: key);
  Task task;
  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final GlobalKey _editKey =GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void _editTask(BuildContext context) {

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
          key: _editKey,
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
                              onPressed: () async {
                                await context
                                    .read<FirebaseService>()
                                    .updateTask(widget.task);
                              
                                Navigator.pop(context);
                              },
                              child: const Text('Change'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
    print('hehe');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: widget.task.isDone!
                              ? TextDecoration.lineThrough
                              : null,
                        )),
                    Text(DateFormat()
                        .add_yMMMd()
                        .format(DateTime.parse(widget.task.date))),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: widget.task.isDone,
                onChanged:
                    (value) async {
                        context.read<HandleTasks>().updateTask(widget.task);
                        await context.read<FirebaseService>().updateTask(widget.task);
                      }

              ),
              PopupMenuButton(
                  itemBuilder: widget.task.isDeleted == false
                      ? (((ctx) => [
                            PopupMenuItem(
                                child: TextButton.icon(
                                    onPressed: () => _editTask(context),
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Edit')),
                                onTap: () => _editTask(context)),

                            PopupMenuItem(
                                child: TextButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete')),
                                onTap: () {
                                  print(context.read<HandleTasks>().items);
                                  context.read<FirebaseService>().removeTask(widget.task);
                                }),
                          ]))
                      : (context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: null,
                                  icon: const Icon(Icons.restore_from_trash),
                                  label: const Text('Restore')),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                                child: TextButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete Forever')),
                                onTap: () {}),
                          ])
            ],
          ),
        ],
      ),
    );
  }
}
