import 'package:flutter/material.dart';

/// Custom Widget untuk memberikan efek Bounce & Fade-In (Konversi dari bounce.xml)
class BounceAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const BounceAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.onTap,
  });

  @override
  State<BounceAnimationWrapper> createState() => _BounceAnimationWrapperState();
}

class _BounceAnimationWrapperState extends State<BounceAnimationWrapper>
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

    // 1. Scale Animation: 0.3 -> 1.0 dengan kurva Elastic/Bounce
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // 2. Alpha/Fade Animation: 0.0 -> 1.0 selama 400ms
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
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
