import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart' as openapi;
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';

class PeopleCard extends StatefulWidget {
  final int? peopleId; // 如果提供了ID，表示编辑现有人物，否则是创建新人物

  const PeopleCard({super.key, this.peopleId});

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isEditMode = false; // 控制是否为编辑模式

  // 表单控制器
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // 人物数据
  openapi.PeopleResponse? _peopleData;
  DateTime? _birthDate;
  // 人名列表
  List<openapi.PeopleNameResponse> _peopleNames = [];

  @override
  void initState() {
    super.initState();
    if (widget.peopleId != null) {
      _loadPeopleData();
      _loadPeopleNames();
    } else {
      // 如果是新建人物，默认进入编辑模式
      _isEditMode = true;
      _peopleNames = [];
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _avatarController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // 加载人物数据
  Future<void> _loadPeopleData() async {
    if (widget.peopleId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await peopleApi.getPeoplePeoplePeopleIdGet(
        peopleId: widget.peopleId!,
      );

      setState(() {
        _peopleData = response.data;
        _descriptionController.text = _peopleData?.description ?? '';
        _avatarController.text = _peopleData?.avatar ?? '';

        if (_peopleData?.birthDate != null) {
          _birthDate = DateTime.tryParse(_peopleData!.birthDate!);
          if (_birthDate != null) {
            _birthDateController.text =
                DateFormat('yyyy-MM-dd').format(_birthDate!);
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载人物信息失败: ${e.toString()}')),
      );
    }
  }

  // 加载人名列表
  Future<void> _loadPeopleNames() async {
    if (widget.peopleId == null) return;
    try {
      final response = await peopleApi.getPeopleNamesPeoplePeopleIdNamesGet(
          peopleId: widget.peopleId!);
      setState(() {
        _peopleNames = response.data?.toList() ?? [];
      });
    } catch (e) {
      setState(() {
        _peopleNames = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载人名失败: ${e.toString()}')),
      );
    }
  }

  // 保存人物数据
  Future<void> _savePeople() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      if (widget.peopleId == null) {
        // 创建新人物
        final peopleCreate = openapi.PeopleCreate((b) => b
          ..description = _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null
          ..avatar =
              _avatarController.text.isNotEmpty ? _avatarController.text : null
          ..birthDate = _birthDateController.text.isNotEmpty
              ? _birthDateController.text
              : null);

        final response = await peopleApi.createPeoplePeoplePost(
          peopleCreate: peopleCreate,
        );

        setState(() {
          _peopleData = response.data;
          _isSaving = false;
          _isEditMode = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('人物创建成功')),
        );
      } else {
        // 更新现有人物
        final peopleUpdate = openapi.PeopleUpdate((b) => b
          ..description = _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null
          ..avatar =
              _avatarController.text.isNotEmpty ? _avatarController.text : null
          ..birthDate = _birthDateController.text.isNotEmpty
              ? _birthDateController.text
              : null);

        final response = await peopleApi.updatePeoplePeoplePeopleIdPut(
          peopleId: widget.peopleId!,
          peopleUpdate: peopleUpdate,
        );

        setState(() {
          _peopleData = response.data;
          _isSaving = false;
          _isEditMode = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('人物信息更新成功')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: ${e.toString()}')),
      );
    }
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RayCard(
      title: Text(widget.peopleId != null ? '编辑人物信息' : '新建人物'),
      trailingActions: [
        if (_isEditMode)
          IconButton(
            icon: Icon(_isSaving ? Icons.hourglass_empty : Icons.check),
            onPressed: _isSaving ? null : _savePeople,
            tooltip: '保存',
          )
        else
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => setState(() => _isEditMode = true),
            tooltip: '编辑',
          ),
      ],
      content: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return _isEditMode ? _buildEditForm() : _buildIdCardView();
  }

  // 构建身份证样式的视图
  Widget _buildIdCardView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 身份证顶部：头像和基本信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像部分
              Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: _peopleData?.avatar != null &&
                        _peopleData!.avatar!.isNotEmpty
                    ? Image.network(
                        _peopleData!.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child:
                              Icon(Icons.person, size: 80, color: Colors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 20),
              // 基本信息部分
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 姓名部分（多名展示）
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: 80,
                            child: Text('姓名',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          child: _buildPeopleNamesTags(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 出生日期部分
                    Row(
                      children: [
                        const SizedBox(
                            width: 80,
                            child: Text('出生日期',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Text(_peopleData?.birthDate ?? '未知',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // ID 部分（如果有）
                    if (_peopleData?.id != null)
                      Row(
                        children: [
                          const SizedBox(
                              width: 80,
                              child: Text('ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Text(_peopleData!.id.toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 描述部分
          const Text('描述',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey.shade50,
              ),
              child: SingleChildScrollView(
                child: Text(
                  _peopleData?.description ?? '暂无描述',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建人名 Tag 组件
  Widget _buildPeopleNamesTags() {
    // 新建人物时只有加号
    if (widget.peopleId == null) {
      return Row(
        children: [
          _buildAddNameTag(),
        ],
      );
    }
    if (_peopleNames.isEmpty) {
      return Row(
        children: [
          _buildAddNameTag(),
        ],
      );
    }
    List<Widget> tags = [];
    for (int i = 0; i < _peopleNames.length; i++) {
      final name = _peopleNames[i];
      tags.add(_buildNameTag(name));
      if (i != _peopleNames.length - 1) {
        tags.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text('/', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ));
      }
    }
    // 加号
    tags.add(_buildAddNameTag());
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: tags,
    );
  }

  Widget _buildNameTag(openapi.PeopleNameResponse name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () => _showEditNameDialog(name),
        child: Chip(
          label: Text(name.name),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => _confirmDeleteName(name),
        ),
      ),
    );
  }

  Widget _buildAddNameTag() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ActionChip(
        avatar: const Icon(Icons.add, size: 16),
        label: const Text('添加'),
        onPressed: _showAddNameDialog,
      ),
    );
  }

  // 编辑人名弹窗
  Future<void> _showEditNameDialog(openapi.PeopleNameResponse name) async {
    final controller = TextEditingController(text: name.name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑人名'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: '人名'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty && result != name.name) {
      await _updatePeopleName(name.id!, result);
    }
  }

  // 添加人名弹窗
  Future<void> _showAddNameDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加人名'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: '人名'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty && widget.peopleId != null) {
      await _createPeopleName(result);
    }
  }

  // 删除人名确认
  Future<void> _confirmDeleteName(openapi.PeopleNameResponse name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除人名'),
        content: Text('确定要删除“${name.name}”吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _deletePeopleName(name.id!);
    }
  }

  // API: 创建人名
  Future<void> _createPeopleName(String name) async {
    try {
      await peopleApi.createPeopleNamePeoplePeopleIdNamesPost(
        peopleId: widget.peopleId!,
        peopleNameCreate: openapi.PeopleNameCreate((b) => b..name = name),
      );
      await _loadPeopleNames();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('添加人名成功')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('添加人名失败: ${e.toString()}')));
    }
  }

  // API: 更新人名
  Future<void> _updatePeopleName(int nameId, String name) async {
    try {
      await peopleApi.updatePeopleNamePeopleNamesNameIdPut(
        nameId: nameId,
        peopleNameCreate: openapi.PeopleNameCreate((b) => b..name = name),
      );
      await _loadPeopleNames();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('人名已更新')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('更新人名失败: ${e.toString()}')));
    }
  }

  // API: 删除人名
  Future<void> _deletePeopleName(int nameId) async {
    try {
      await peopleApi.deletePeopleNamePeopleNamesNameIdDelete(nameId: nameId);
      await _loadPeopleNames();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('人名已删除')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('删除人名失败: ${e.toString()}')));
    }
  }

  // 构建编辑表单
  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 姓名部分（暂时保持固定）
              const Text('姓名', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('张三（姓名功能将在单独的模块中实现）',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
              const SizedBox(height: 16),

              // 头像URL
              TextFormField(
                controller: _avatarController,
                decoration: const InputDecoration(
                  labelText: '头像URL',
                  hintText: '输入图像的URL地址',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 16),

              // 出生日期
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: '出生日期',
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 描述
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: '描述',
                  hintText: '输入人物的描述信息',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // 预览头像（如果有URL）
              if (_avatarController.text.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('头像预览',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Image.network(
                        _avatarController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.error_outline,
                              color: Colors.red, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
