import 'package:flutter/material.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/commands/command.dart';

final schedulerCommands = Command(
  command: 'scheduler',
  title: '调度',
  icon: Icons.schedule,
  subCommands: [
    Command(
      command: 'task-list',
      title: '任务表',
      icon: Icons.view_list,
      callback: (context, cardManager) async {
        final result = await api.getScheduledTasksSchedulerTasksGet();

        cardManager.addCard(Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '定时任务列表',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                    4: IntrinsicColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('任务ID',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('类型',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('间隔',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('标签',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('下次运行时间',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...(result.data?.toList() ?? []).map(
                      (task) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.id),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.taskType),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.interval.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.tag),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.nextRun.toLocal().toString()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      },
    ),
  ],
);
