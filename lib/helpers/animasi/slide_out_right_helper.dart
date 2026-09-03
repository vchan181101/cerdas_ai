import 'package:flutter/material.dart';

/// Custom Widget untuk efek Slide-Out Right (Konversi dari slide_out_right.xml)
class SlideOutRightAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onAnimationEnd;

  const SlideOutRightAnimationWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.onAnimationEnd,
  });

  @override
  State<SlideOutRightAnimationWrapper> createState() =>
      _SlideOutRightAnimationWrapperState();
}

class _SlideOutRightAnimationWrapperState
    extends State<SlideOutRightAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // 1. Slide Animation: Bergeser dari X: 0.0 ke X: 1.0 (100% kanan) dengan accelerate curve
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn, // Padanan accelerate_interpolator
      ),
    );

    // 2. Fade Animation: Transparansi 1.0 -> 0.0 selama 400ms pertama (0.8 interval dari 500ms)
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
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

  void startSlideOut() {
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
    // Sembunyikan widget dari tree jika animasi telah selesai (setara View.GONE)
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: startSlideOut,
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