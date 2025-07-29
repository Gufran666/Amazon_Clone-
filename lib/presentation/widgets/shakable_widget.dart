// shakable_widget.dart
import 'package:flutter/material.dart';

class ShakableWidget extends StatefulWidget {
  final Widget child;
  final bool isShaking;
  const ShakableWidget({
    super.key,
    required this.child,
    required this.isShaking,
  });

  @override
  State<ShakableWidget> createState() => _ShakableWidgetState();
}

class _ShakableWidgetState extends State<ShakableWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShaking && !oldWidget.isShaking) {
      _controller.repeat(reverse: true);
    }
    if (!widget.isShaking && oldWidget.isShaking) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}