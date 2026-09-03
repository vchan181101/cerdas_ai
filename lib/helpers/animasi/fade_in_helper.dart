import 'package:flutter/material.dart';

/// Custom Widget untuk efek Fade-In (Konversi dari fade_in.xml)
class FadeInAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const FadeInAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.onTap,
  });

  @override
  State<FadeInAnimationWrapper> createState() => _FadeInAnimationWrapperState();
}

class _FadeInAnimationWrapperState extends State<FadeInAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Fade-In: 0.0 -> 1.0 dengan kurva AccelerateDecelerate (Konversi fade_in.xml)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Padanan accelerate_decelerate_interpolator
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
        child: widget.child,
      ),
    );
  }
}