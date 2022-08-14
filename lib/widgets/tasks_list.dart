import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/utils/ThemeColor.dart';
import 'package:pomodoro/widgets/task_tile.dart';

import '../providers/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  final Set<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ExpansionPanelList.radio(
        children: taskList
            .map((task) => ExpansionPanelRadio(
                backgroundColor: task.isDone!
                    ? Theme.of(context).accentColor.withOpacity(0.3)
                    : Theme.of(context).accentColor,
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
                      text: '${task.title}\n\n',
                    ),
                    const TextSpan(
                      text: 'Description\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${task.description}\n\n',
                    ),
                    const TextSpan(
                      text: 'Time\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '${DateFormat()
                          .add_yMMMd()
                          .add_Hms()
                          .format(DateTime.parse(task.date))}\n\n',
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
