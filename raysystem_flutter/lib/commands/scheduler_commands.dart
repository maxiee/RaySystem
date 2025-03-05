import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
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
                    0: IntrinsicColumnWidth(), // ID
                    1: IntrinsicColumnWidth(), // 任务类型
                    2: IntrinsicColumnWidth(), // 调度类型
                    3: IntrinsicColumnWidth(), // 调度详情
                    4: IntrinsicColumnWidth(), // 标签
                    5: IntrinsicColumnWidth(), // 参数
                    6: IntrinsicColumnWidth(), // 状态
                    7: IntrinsicColumnWidth(), // 下次运行时间
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
                          child: Text('任务类型',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('调度类型',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('调度详情',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('标签',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('参数',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('状态',
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
                          // 任务ID
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.id),
                          ),
                          // 任务类型
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.taskType),
                          ),
                          // 调度类型
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text(_getScheduleTypeText(task.scheduleType)),
                          ),
                          // 调度详情
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_getScheduleDetails(task)),
                          ),
                          // 标签
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.tag),
                          ),
                          // 参数
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              task.parameters.toString().length > 30
                                  ? '${task.parameters.toString().substring(0, 30)}...'
                                  : task.parameters.toString(),
                            ),
                          ),
                          // 状态
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task.enabled
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Text(task.enabled ? '启用' : '禁用'),
                              ],
                            ),
                          ),
                          // 下次运行时间
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

String _getScheduleTypeText(TaskScheduleType type) {
  switch (type) {
    case TaskScheduleType.INTERVAL:
      return '间隔';
    case TaskScheduleType.CRON:
      return 'Cron表达式';
    case TaskScheduleType.EVENT:
      return '事件触发';
    case TaskScheduleType.MANUAL:
      return '手动';
    default:
      return '未知';
  }
}

String _getScheduleDetails(ScheduledTaskResponse task) {
  switch (task.scheduleType) {
    case TaskScheduleType.INTERVAL:
      return '每 ${task.interval} 秒';
    case TaskScheduleType.CRON:
      return task.cronExpression ?? '无表达式';
    case TaskScheduleType.EVENT:
      return task.eventType ?? '无事件类型';
    case TaskScheduleType.MANUAL:
      return '手动触发';
    default:
      return '-';
  }
}
