import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/module/people/cards/people_card/people_card.dart';

class RecentPeopleViewModel extends ChangeNotifier {
  static const int _pageSize = 20;

  List<PeopleResponse> _people = [];
  bool _isLoading = false;
  bool _isInitialLoading = false;
  bool _hasMore = true;
  String? _error;
  int _currentPage = 0;

  List<PeopleResponse> get people => _people;
  bool get isLoading => _isLoading;
  bool get isInitialLoading => _isInitialLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  /// 加载初始数据
  Future<void> loadInitialData() async {
    if (_isInitialLoading) return;

    _isInitialLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _loadPeopleData(isRefresh: true);
    } catch (e) {
      _error = _handleError(e);
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  /// 刷新数据
  Future<void> refresh() async {
    if (_isLoading) return;

    _error = null;
    _currentPage = 0;
    _hasMore = true;

    await _loadPeopleData(isRefresh: true);
  }

  /// 加载更多数据
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    await _loadPeopleData(isRefresh: false);
  }

  /// 加载人物数据的核心方法
  Future<void> _loadPeopleData({required bool isRefresh}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 由于当前API没有专门的"最近添加"接口，我们使用搜索接口
      // 这里用一个通用的搜索来模拟获取所有人物
      // 在实际应用中，你可能需要后端提供专门的接口
      final response = await _fetchRecentPeople();

      if (response.data != null) {
        List<PeopleResponse> newPeople = response.data!.toList();

        // 按ID降序排列（假设ID越大越新）
        newPeople.sort((a, b) => b.id.compareTo(a.id));

        if (isRefresh) {
          _people = [];
          _currentPage = 0;
        }

        // 实现客户端分页
        final startIndex = _currentPage * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, newPeople.length);
        final pageData = newPeople.sublist(startIndex, endIndex);

        _people.addAll(pageData);
        _currentPage++;

        // 检查是否还有更多数据
        _hasMore = endIndex < newPeople.length;
      } else {
        if (isRefresh) {
          _people = [];
        }
        _hasMore = false;
      }
    } catch (e) {
      _error = _handleError(e);
      if (isRefresh) {
        _people = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 获取最近人物的API调用
  /// 由于没有专门的最近人物接口，这里使用搜索接口来模拟
  Future<Response<BuiltList<PeopleResponse>>> _fetchRecentPeople() async {
    // 这里使用一个通用搜索，在实际应用中应该有专门的API
    // 例如: GET /people/recent?page=0&size=20&sort=created_desc

    try {
      // 尝试用常见的中文姓氏来搜索，获取一些人物数据
      // 在实际项目中，这应该是一个专门的API调用
      final commonNames = [
        '张',
        '王',
        '李',
        '赵',
        '刘',
        '陈',
        '杨',
        '吴',
        '周',
        '郑',
        '孙',
        '马',
        '朱',
        '胡',
        '林',
        '郭',
        '何',
        '高',
        '罗',
        '郑'
      ];

      List<PeopleResponse> allPeople = [];

      // 为了获取更多样的数据，我们搜索多个常见姓氏
      for (String name in commonNames.take(5)) {
        // 限制搜索次数以避免过多请求
        try {
          final response =
              await peopleApi.searchPeoplePeopleSearchGet(name: name);
          if (response.data != null) {
            allPeople.addAll(response.data!.toList());
          }
        } catch (e) {
          // 忽略单个搜索的错误，继续下一个
          continue;
        }
      }

      // 去重（基于ID）
      final uniquePeople = <int, PeopleResponse>{};
      for (var person in allPeople) {
        uniquePeople[person.id] = person;
      }

      // 转换为列表并按ID排序（模拟按创建时间排序）
      final sortedPeople = uniquePeople.values.toList()
        ..sort((a, b) => b.id.compareTo(a.id));

      final result = BuiltList<PeopleResponse>(sortedPeople);

      return Response(
        data: result,
        requestOptions: RequestOptions(path: '/people/recent'),
      );
    } catch (e) {
      // 如果所有搜索都失败，返回空结果
      return Response(
        data: BuiltList<PeopleResponse>([]),
        requestOptions: RequestOptions(path: '/people/recent'),
      );
    }
  }

  /// 处理错误信息
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return '连接超时，请检查网络连接';
        case DioExceptionType.receiveTimeout:
          return '接收数据超时，请重试';
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 404) {
            return '服务不可用';
          } else if (error.response?.statusCode == 500) {
            return '服务器内部错误';
          }
          return '请求失败: ${error.response?.statusCode}';
        case DioExceptionType.connectionError:
          return '网络连接错误，请检查网络设置';
        default:
          return '网络请求失败: ${error.message}';
      }
    }
    return '发生未知错误: $error';
  }

  /// 查看人物详情
  void viewPerson(BuildContext context, PeopleResponse person) {
    showDialog(
      context: context,
      builder: (context) => _PersonDetailDialog(person: person),
    );
  }

  /// 编辑人物
  void editPerson(BuildContext context, int peopleId) {
    // 这里可以通过路由或者其他方式打开编辑界面
    // 暂时使用对话框的形式
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 500,
          child: PeopleCard(peopleId: peopleId),
        ),
      ),
    );
  }
}

/// 人物详情对话框
class _PersonDetailDialog extends StatelessWidget {
  final PeopleResponse person;

  const _PersonDetailDialog({required this.person});

  @override
  Widget build(BuildContext context) {
    final firstNameStr =
        person.names?.isNotEmpty == true ? person.names!.first.name : '未命名';

    return AlertDialog(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              firstNameStr.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              firstNameStr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (person.description != null &&
                person.description!.isNotEmpty) ...[
              const Text(
                '描述',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(person.description!),
              const SizedBox(height: 16),
            ],
            if (person.birthDate != null) ...[
              const Text(
                '出生日期',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(person.birthDate!.toString()),
              const SizedBox(height: 16),
            ],
            if (person.names != null && person.names!.isNotEmpty) ...[
              const Text(
                '所有名称',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...person.names!.map((name) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text(name.name)),
                      ],
                    ),
                  )),
            ],
            const SizedBox(height: 16),
            const Text(
              'ID',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('${person.id}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // 这里可以添加编辑逻辑
          },
          child: const Text('编辑'),
        ),
      ],
    );
  }
}
