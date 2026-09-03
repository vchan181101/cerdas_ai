import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class SlideOutRightExampleScreen extends StatelessWidget {
  const SlideOutRightExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slide-Out Right Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideOutRightAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              onAnimationEnd: () => debugPrint('Selesai keluar ke kanan'),
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon untuk menggeser keluar ke kanan'),
          ],
        ),
      ),
    );
  }
}
