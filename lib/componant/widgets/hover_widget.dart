import 'package:flutter/material.dart';

class HoverWidget extends StatefulWidget {
  final Widget? body;
  final Function(bool) onHoverChanged;

  const HoverWidget({Key? key, this.body, required this.onHoverChanged})
      : super(key: key);

  @override
  _HoverWidgetState createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onHoverChanged(isHovered);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: widget.body!,
    );
  }
}
