import 'package:flutter/material.dart';

class AnimatedExpansionIcon extends StatefulWidget {
  final bool isExpanded;

  const AnimatedExpansionIcon({required this.isExpanded, super.key});

  @override
  State<AnimatedExpansionIcon> createState() => _AnimatedExpansionIconState();
}

class _AnimatedExpansionIconState extends State<AnimatedExpansionIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedExpansionIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller.drive(Tween<double>(begin: 0.0, end: 0.5)),
      child: const Icon(Icons.expand_more),
    );
  }
}
