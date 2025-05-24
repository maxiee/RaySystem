import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';
import 'recent_people_view_model.dart';

class RecentPeopleCard extends StatelessWidget {
  const RecentPeopleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecentPeopleViewModel()..loadInitialData(),
      child: Consumer<RecentPeopleViewModel>(
        builder: (context, viewModel, child) {
          return RayCard(
            title: const Text('最近添加的人物'),
            trailingActions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: viewModel.isLoading ? null : viewModel.refresh,
                tooltip: '刷新',
              ),
            ],
            content: _buildContent(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, RecentPeopleViewModel viewModel) {
    if (viewModel.isInitialLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在加载最近添加的人物...'),
          ],
        ),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              viewModel.error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.refresh,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (viewModel.people.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '还没有添加任何人物',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 人物列表
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollEndNotification &&
                  scrollInfo.metrics.extentAfter < 200 &&
                  !viewModel.isLoading &&
                  viewModel.hasMore) {
                viewModel.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              itemCount: viewModel.people.length + (viewModel.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index >= viewModel.people.length) {
                  // 加载更多指示器
                  return _buildLoadMoreIndicator(viewModel);
                }

                final person = viewModel.people[index];
                return _buildPersonTile(context, person, viewModel);
              },
            ),
          ),
        ),

        // 底部信息栏
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '已显示 ${viewModel.people.length} 人',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (viewModel.hasMore)
                Text(
                  '上拉加载更多',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonTile(
      BuildContext context, person, RecentPeopleViewModel viewModel) {
    final firstNameStr =
        person.names?.isNotEmpty == true ? person.names!.first.name : '未命名';
    final otherNamesCount = (person.names?.length ?? 0) - 1;
    final otherNames = otherNamesCount > 0 ? '(+$otherNamesCount个其他名称)' : '';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          firstNameStr.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              firstNameStr,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (otherNames.isNotEmpty)
            Text(
              otherNames,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
        ],
      ),
      subtitle: person.description != null && person.description!.isNotEmpty
          ? Text(
              person.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              viewModel.editPerson(context, person.id);
              break;
            case 'view':
              viewModel.viewPerson(context, person);
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: ListTile(
              leading: Icon(Icons.visibility),
              title: Text('查看详情'),
              dense: true,
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('编辑'),
              dense: true,
            ),
          ),
        ],
      ),
      onTap: () => viewModel.viewPerson(context, person),
    );
  }

  Widget _buildLoadMoreIndicator(RecentPeopleViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (viewModel.isLoading) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            const Text('正在加载更多...'),
          ] else ...[
            const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
            const SizedBox(width: 8),
            const Text(
              '上拉加载更多',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
