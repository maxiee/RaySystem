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
  int _currentPage = 1;

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
    _currentPage = 1;
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
      if (isRefresh) {
        _people = [];
        _currentPage = 1; // 页码从1开始
      } else {
        _currentPage++; // 加载下一页
      }

      // 使用真正的分页接口获取最近添加的人物
      // API 按主键倒序排列，最新创建的人物在前面
      final response = await peopleApi.getPeopleListPeopleGet(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response.data != null) {
        final peopleListResponse = response.data!;

        // 将新数据添加到现有列表
        _people.addAll(peopleListResponse.items.toList());

        // 检查是否还有更多数据
        _hasMore = _currentPage < peopleListResponse.totalPages;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _error = _handleError(e);
      if (isRefresh) {
        _people = [];
      }
      // 如果加载失败，回退页码
      if (!isRefresh && _currentPage > 1) {
        _currentPage--;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
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
