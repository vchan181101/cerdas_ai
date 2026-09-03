import 'package:flutter/material.dart';

/// Custom Widget untuk efek Slide-In Left (Konversi dari slide_in_left.xml)
class SlideInLeftAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const SlideInLeftAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.onTap,
  });

  @override
  State<SlideInLeftAnimationWrapper> createState() => _SlideInLeftAnimationWrapperState();
}

class _SlideInLeftAnimationWrapperState extends State<SlideInLeftAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 1. Slide Animation: Bergeser dari X: -1.0 (-100%) ke X: 0.0 dengan decelerate curve
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );

    // 2. Fade Animation: Transparansi 0.0 -> 1.0 selama 400ms pertama
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
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
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}