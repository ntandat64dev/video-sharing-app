import 'package:flutter/material.dart';

class SinkAnimated extends StatefulWidget {
  const SinkAnimated({
    super.key,
    required this.onTap,
    required this.child,
    this.level = 0.05,
  });

  final Function onTap;
  final Widget child;
  final double level;

  @override
  State<SinkAnimated> createState() => _SinkAnimatedState();
}

class _SinkAnimatedState extends State<SinkAnimated> with SingleTickerProviderStateMixin {
  static const clickAnimationDurationMillis = 100;

  double _scaleTransformValue = 1;

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: clickAnimationDurationMillis),
      lowerBound: 0.0,
      upperBound: widget.level,
    )..addListener(() {
        setState(() => _scaleTransformValue = 1 - animationController.value);
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _shrinkButtonSize() {
    animationController.forward();
  }

  void _restoreButtonSize() {
    Future.delayed(
      const Duration(milliseconds: clickAnimationDurationMillis),
      () => animationController.reverse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap.call();
        _shrinkButtonSize();
        _restoreButtonSize();
      },
      onTapDown: (_) => _shrinkButtonSize(),
      onTapCancel: _restoreButtonSize,
      child: Transform.scale(
        scale: _scaleTransformValue,
        child: widget.child,
      ),
    );
  }
}
