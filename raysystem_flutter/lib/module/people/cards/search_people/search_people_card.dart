import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';

class SearchPeopleCard extends StatefulWidget {
  const SearchPeopleCard({super.key});

  @override
  State<SearchPeopleCard> createState() => _SearchPeopleCardState();
}

class _SearchPeopleCardState extends State<SearchPeopleCard> {
  final TextEditingController _controller = TextEditingController();
  List<PeopleResponse> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _onSearch() async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _searchResults = [];
    });

    try {
      final response = await peopleApi.searchPeoplePeopleSearchGet(
        name: _controller.text.trim(),
      );

      setState(() {
        _searchResults = response.data?.toList() ?? [];
        _isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = '搜索失败: ${e.message}';
        _isLoading = false;
      });
      print('搜索失败: ${e.message}');
    } catch (e) {
      setState(() {
        _error = '发生错误: $e';
        _isLoading = false;
      });
      print('发生错误: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RayCard(
      title: Text('搜索人物'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '输入名称',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _onSearch,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('搜索'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildResultsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsWidget() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      if (_controller.text.isEmpty) {
        return const Center(child: Text('输入名称开始搜索'));
      } else {
        return const Center(child: Text('没有找到匹配的人物'));
      }
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final person = _searchResults[index];
        final firstNameStr =
            person.names?.isNotEmpty == true ? person.names!.first.name : '未命名';
        final otherNames = (person.names?.length ?? 0) > 1
            ? '(${person.names!.length - 1}个其他名称)'
            : '';

        return ListTile(
          leading: CircleAvatar(
            child: Text(firstNameStr.substring(0, 1)),
          ),
          title: Text('$firstNameStr $otherNames'),
          subtitle: person.description != null
              ? Text(person.description!,
                  maxLines: 1, overflow: TextOverflow.ellipsis)
              : null,
          trailing: ElevatedButton(
            onPressed: () {}, // 留给以后实现
            child: const Text('详情'),
          ),
        );
      },
    );
  }
}
