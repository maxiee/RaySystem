import 'package:flutter/material.dart';

/// macOS 风格的关闭按钮（红色圆形）
class MacOSCloseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const MacOSCloseButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MacOSCloseButton> createState() => _MacOSCloseButtonState();
}

class _MacOSCloseButtonState extends State<MacOSCloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.red.shade700 : Colors.red,
            shape: BoxShape.circle,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ]
                : null,
          ),
          child: _isHovered
              ? const Icon(
                  Icons.close,
                  size: 10,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
