import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/crud/note_tree_crud_provider.dart';

class NewNoteTreeView extends ConsumerStatefulWidget {
  const NewNoteTreeView({super.key});

  @override
  ConsumerState<NewNoteTreeView> createState() => _NewNoteTreeViewState();
}

class _NewNoteTreeViewState extends ConsumerState<NewNoteTreeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noteTreeCrudProvider).refreshingTree();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeState = ref.watch(noteTreeProvider);
    // 在这里返回您的树结构视图
    return const SizedBox(); // 临时返回一个空容器，请替换为您的实际Widget
  }
}
