import 'package:flutter/material.dart';

/// Custom Widget untuk efek Fade-Out (Konversi dari fade_out.xml)
class FadeOutAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onAnimationEnd;

  const FadeOutAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.onAnimationEnd,
  });

  @override
  State<FadeOutAnimationWrapper> createState() => _FadeOutAnimationWrapperState();
}

class _FadeOutAnimationWrapperState extends State<FadeOutAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Fade-Out: 1.0 -> 0.0 dengan kurva Accelerate (Curves.easeIn)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Listener saat animasi selesai untuk menyembunyikan widget (setara View.GONE)
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isVisible = false;
        });
        if (widget.onAnimationEnd != null) {
          widget.onAnimationEnd!();
        }
      }
    });
  }

  void startFadeOut() {
    setState(() {
      _isVisible = true;
    });
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
    // Jika animasi selesai, hilangkan widget dari tree (setara View.GONE)
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: startFadeOut,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}