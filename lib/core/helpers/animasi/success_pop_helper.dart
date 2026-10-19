import 'package:flutter/material.dart';

/// Custom Widget untuk efek Success Pop (Konversi dari success_pop.xml)
class SuccessPopAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const SuccessPopAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700), // Total 500ms + 200ms
    this.onTap,
  });

  @override
  State<SuccessPopAnimationWrapper> createState() =>
      _SuccessPopAnimationWrapperState();
}

class _SuccessPopAnimationWrapperState extends State<SuccessPopAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 1. Scale Animation dengan TweenSequence: 0.0 -> 1.1 (500ms) -> 1.0 (200ms)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 500 / 700,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 200 / 700,
      ),
    ]).animate(_controller);

    // 2. Fade-In Animation: Transparansi 0.0 -> 1.0 selama 400ms pertama (400/700 interval)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 400 / 700, curve: Curves.easeIn),
      ),
    );

    playAnimation();
  }

  void playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playAnimation();
        if (widget.onTap != null) widget.onTap!();
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}