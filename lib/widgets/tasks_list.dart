import 'package:flutter/material.dart';
import 'package:pomodoro/widgets/task_tile.dart';

import '../providers/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ExpansionPanelList.radio(
        children: taskList
            .map((task) => ExpansionPanelRadio(
                backgroundColor: task.isDone!
                    ? const Color(0xfff6f7dd).withOpacity(0.3)
                    : const Color(0xfff6f7dd),
                value: task.id,
                headerBuilder: (context, isOpen) => TaskTile(
                      task: task,
                    ),
                body: ListTile(
                  title: SelectableText.rich(TextSpan(children: [
                    const TextSpan(
                      text: 'Text\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${task.title}\n',
                    ),
                    const TextSpan(
                      text: 'Description\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${task.description}\n',
                    ),
                  ])),
                )))
            .toList(),
      ),
    );
    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: taskList.length,
    //     itemBuilder: (_, i) {
    //       var task = taskList[i];
    //       return ListTiles(task: task);
    //     },
    //   ),
    // );
  }
}
