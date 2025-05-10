import 'package:flutter/material.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';

class SearchPeopleCard extends StatefulWidget {
  const SearchPeopleCard({super.key});

  @override
  State<SearchPeopleCard> createState() => _SearchPeopleCardState();
}

class _SearchPeopleCardState extends State<SearchPeopleCard> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _searchResults = [];

  void _onSearch() {
    setState(() {
      // 模拟搜索结果
      _searchResults.clear();
      if (_controller.text.isNotEmpty) {
        _searchResults.addAll(
            List.generate(5, (index) => '${_controller.text} - 结果 $index'));
      }
    });
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
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  child: const Text('搜索'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                  trailing: ElevatedButton(
                    onPressed: () {}, // 留给以后实现
                    child: const Text('操作'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
