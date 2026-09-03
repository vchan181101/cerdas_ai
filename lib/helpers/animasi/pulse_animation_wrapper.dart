import 'package:flutter/material.dart';

class PulseAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double pulseScale;

  const PulseAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.pulseScale = 1.1,
  });

  @override
  State<PulseAnimationWrapper> createState() => _PulseAnimationWrapperState();
}

class _PulseAnimationWrapperState extends State<PulseAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: widget.pulseScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
