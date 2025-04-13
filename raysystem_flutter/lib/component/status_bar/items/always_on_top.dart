import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AlwaysOnTopItem extends StatefulWidget {
  const AlwaysOnTopItem({super.key});

  @override
  State<AlwaysOnTopItem> createState() => _AlwaysOnTopItemState();
}

class _AlwaysOnTopItemState extends State<AlwaysOnTopItem> {
  bool isAlwaysOnTop = false;

  void toggleAlwaysOnTop() async {
    setState(() {
      isAlwaysOnTop = !isAlwaysOnTop;
    });
    print("Window always on top: $isAlwaysOnTop");
    await windowManager.setAlwaysOnTop(isAlwaysOnTop);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isAlwaysOnTop ? theme.colorScheme.primary : theme.disabledColor;

    return Tooltip(
        message: 'Always on top',
        child: TextButton(
          onPressed: toggleAlwaysOnTop,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            minimumSize: Size.zero, // 移除最小尺寸限制
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 使点击区域包裹内容
          ),
          child: Text('TOP',
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ));
  }
}
