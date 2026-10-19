import 'package:flutter/material.dart';

/// Custom Widget untuk efek Fade-In Slow dengan Delay (Konversi dari fade_in_slow.xml)
class FadeInSlowAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final VoidCallback? onTap;

  const FadeInSlowAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 300),
    this.onTap,
  });

  @override
  State<FadeInSlowAnimationWrapper> createState() => _FadeInSlowAnimationWrapperState();
}

class _FadeInSlowAnimationWrapperState extends State<FadeInSlowAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Total durasi animasi gabungan dari delay (300ms) + durasi fade (800ms) = 1100ms
    final totalDuration = widget.delay + widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    // Menghitung Interval persentase dimulainya transparansi setelah delay 300ms
    final startInterval = widget.delay.inMilliseconds / totalDuration.inMilliseconds;

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(startInterval, 1.0, curve: Curves.easeIn),
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