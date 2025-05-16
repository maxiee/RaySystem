import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart' as openapi;
import 'package:raysystem_flutter/component/card/ray_card.dart';
import 'package:provider/provider.dart'; // Add Provider
import 'people_card_view_model.dart'; // Import the ViewModel

class PeopleCard extends StatelessWidget {
  // Change to StatelessWidget
  final int? peopleId;

  const PeopleCard({super.key, this.peopleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeopleCardViewModel(peopleId: peopleId),
      child: Consumer<PeopleCardViewModel>(
        builder: (context, viewModel, child) {
          // Listen for messages and show SnackBars
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(viewModel.successMessage!)),
              );
              viewModel.clearMessages();
            }
            if (viewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(viewModel.errorMessage!)),
              );
              viewModel.clearMessages();
            }
          });

          return RayCard(
            title: Text(peopleId != null ? '编辑人物信息' : '新建人物'),
            trailingActions: [
              IconButton(
                icon: Icon(
                    viewModel.isSaving ? Icons.hourglass_empty : Icons.check),
                onPressed: viewModel.isSaving ? null : viewModel.savePeople,
                tooltip: '保存',
              )
            ],
            content: _buildCardContent(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(
      BuildContext context, PeopleCardViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildEditForm(context, viewModel);
  }

  // 选择日期
  Future<void> _selectDate(
      BuildContext context, PeopleCardViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.birthDateController.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(viewModel.birthDateController.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    viewModel.selectDate(picked);
  }

  // 编辑人名弹窗
  Future<void> _showEditNameDialog(BuildContext context,
      PeopleCardViewModel viewModel, openapi.PeopleNameResponse name) async {
    final controller = TextEditingController(text: name.name);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('编辑人名'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: '人名'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty && result != name.name) {
      await viewModel.updatePeopleName(name.id, result); // Removed !
    }
  }

  // 添加人名弹窗
  Future<void> _showAddNameDialog(
      BuildContext context, PeopleCardViewModel viewModel) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('添加人名'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: '人名'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      await viewModel.createPeopleName(result);
    }
  }

  // 删除人名确认
  Future<void> _confirmDeleteName(BuildContext context,
      PeopleCardViewModel viewModel, openapi.PeopleNameResponse name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除人名'),
        content: Text('确定要删除“${name.name}”吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await viewModel.deletePeopleName(name.id); // Removed !
    }
  }

  // 构建人名 Tag 组件
  Widget _buildPeopleNamesTags(
      BuildContext context, PeopleCardViewModel viewModel) {
    // 新建人物时只显示添加按钮
    if (viewModel.peopleId == null) {
      return Row(
        children: [
          _buildAddNameTag(context, viewModel),
        ],
      );
    }

    if (viewModel.peopleNames.isEmpty) {
      return Row(
        children: [
          _buildAddNameTag(context, viewModel),
        ],
      );
    }

    List<Widget> tags = [];
    for (int i = 0; i < viewModel.peopleNames.length; i++) {
      final name = viewModel.peopleNames[i];
      tags.add(_buildNameTag(context, viewModel, name));
      if (i != viewModel.peopleNames.length - 1) {
        tags.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text('/', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ));
      }
    }

    // 添加标签按钮
    tags.add(_buildAddNameTag(context, viewModel));

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: tags,
    );
  }

  Widget _buildNameTag(BuildContext context, PeopleCardViewModel viewModel,
      openapi.PeopleNameResponse name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () => _showEditNameDialog(context, viewModel, name),
        child: Chip(
          label: Text(name.name),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () => _confirmDeleteName(context, viewModel, name),
        ),
      ),
    );
  }

  Widget _buildAddNameTag(BuildContext context, PeopleCardViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ActionChip(
        avatar: const Icon(Icons.add, size: 16),
        label: const Text('添加'),
        onPressed: () =>
            (viewModel.peopleData?.id ?? viewModel.peopleId) == null
                ? _showSaveFirstDialog(context, viewModel)
                : _showAddNameDialog(context, viewModel),
      ),
    );
  }

  // 提示先保存人物信息的对话框
  Future<void> _showSaveFirstDialog(
      BuildContext context, PeopleCardViewModel viewModel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('需要先保存'),
        content: const Text('添加人名前需要先保存人物基本信息，是否现在保存？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('保存', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
    if (result == true) {
      // 使用带回调的保存方法，如果保存成功直接打开添加人名对话框
      final success = await viewModel.savePeople();
      if (success) {
        // 保存成功后直接打开添加人名对话框
        await _showAddNameDialog(context, viewModel);
      }
    }
  }

  // 构建统一的表单内容
  Widget _buildEditForm(BuildContext context, PeopleCardViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: viewModel.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 姓名
              const Text('姓名', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildPeopleNamesTags(context, viewModel),
              const SizedBox(height: 16),

              // 头像URL
              const Text('头像URL',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: viewModel.avatarController,
                decoration: const InputDecoration(
                  hintText: '输入图像的URL地址',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 16),

              // 出生日期
              const Text('出生日期', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context, viewModel),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: viewModel.birthDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 描述
              const Text('描述', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: viewModel.descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '输入人物的描述信息',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 预览头像
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: viewModel.avatarController,
                builder: (context, value, child) {
                  if (value.text.isNotEmpty) {
                    return Column(
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
                            value.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(Icons.error_outline,
                                  color: Colors.red, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // ID (仅显示已有的ID)
              if (viewModel.peopleData?.id != null) ...[
                const Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(viewModel.peopleData!.id.toString()),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Removed _PeopleCardState class and all its methods as they are now in PeopleCardViewModel
