import 'dart:ui';
import 'package:flutter/material.dart';

class BlurRevealAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double beginBlur;
  final double endBlur;

  const BlurRevealAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.beginBlur = 10.0,
    this.endBlur = 0.0,
  });

  @override
  State<BlurRevealAnimation> createState() => _BlurRevealAnimationState();
}

class _BlurRevealAnimationState extends State<BlurRevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _blurAnimation = Tween<double>(begin: widget.beginBlur, end: widget.endBlur).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAnimation.value,
              sigmaY: _blurAnimation.value,
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
