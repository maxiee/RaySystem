import 'package:flutter/material.dart';
import 'package:raysystem_flutter/api/api.dart'; // 添加这一行
import 'package:raysystem_flutter/commands/command.dart';

final infoCommands = Command(
  command: 'info-app',
  title: '资讯',
  icon: Icons.article,
  subCommands: [
    Command(
      command: 'info-list',
      title: '资讯列表',
      icon: Icons.list_alt,
      callback: (context, cardManager) async {
        final result = await api.getInfosInfosGet(
          limit: 10,
          createdBefore: DateTime.now().toUtc(),
        );

        cardManager.addCard(Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '最新资讯',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...result.data!.items
                  .map(
                    (info) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(info.title),
                          subtitle: info.description != null
                              ? Text(
                                  info.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: info.isNew
                              ? const Chip(
                                  label: Text('NEW'),
                                  backgroundColor: Colors.red,
                                  labelStyle: TextStyle(color: Colors.white),
                                )
                              : null,
                          onTap: () {
                            // TODO: 打开资讯详情
                          },
                        ),
                        if (info != result.data!.items.last) const Divider(),
                      ],
                    ),
                  )
                  .toList(),
              if (result.data!.hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: 加载更多
                      },
                      child: const Text('加载更多'),
                    ),
                  ),
                ),
            ],
          ),
        ));
      },
    ),
    Command(
      command: 'info-stats',
      title: '资讯统计',
      icon: Icons.analytics,
      callback: (context, cardManager) async {
        final result = await api.getInfoStatsInfosStatsGet();

        cardManager.addCard(Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '资讯统计',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('统计项',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('数量',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('总数'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${result.data?.totalCount ?? 0}'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('未读'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${result.data?.unreadCount ?? 0}'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('已标记'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${result.data?.markedCount ?? 0}'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
      },
    ),
  ],
);
