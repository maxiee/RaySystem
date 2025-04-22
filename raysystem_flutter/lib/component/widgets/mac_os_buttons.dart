import 'package:flutter/material.dart';

/// 通用的 macOS 风格窗口按钮（圆形，支持自定义颜色和图标）
class _MacOSWindowButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color hoverColor;
  final IconData? icon;
  final Color? iconColor;

  const _MacOSWindowButton({
    Key? key,
    required this.onPressed,
    required this.color,
    required this.hoverColor,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  State<_MacOSWindowButton> createState() => _MacOSWindowButtonState();
}

class _MacOSWindowButtonState extends State<_MacOSWindowButton> {
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
            color: _isHovered ? widget.hoverColor : widget.color,
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
          child: _isHovered && widget.icon != null
              ? Icon(
                  widget.icon,
                  size: 10,
                  color: widget.iconColor ?? Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

/// macOS 风格的关闭按钮（红色圆形）
class MacOSCloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MacOSCloseButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MacOSWindowButton(
      onPressed: onPressed,
      color: Colors.red,
      hoverColor: Colors.red.shade700,
      icon: Icons.close,
      iconColor: Colors.white,
    );
  }
}

/// macOS 风格的最小化按钮（黄色圆形）
class MacOSMinimizeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MacOSMinimizeButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MacOSWindowButton(
      onPressed: onPressed,
      color: Colors.yellow[700]!,
      hoverColor: Colors.yellow[800]!,
      icon: Icons.remove,
      iconColor: Colors.white,
    );
  }
}

/// macOS 风格的最大化按钮（绿色圆形）
class MacOSMaximizeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MacOSMaximizeButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MacOSWindowButton(
      onPressed: onPressed,
      color: Colors.green,
      hoverColor: Colors.green.shade700,
      icon: Icons.crop_square,
      iconColor: Colors.white,
    );
  }
}
