import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class SlideOutLeftExampleScreen extends StatelessWidget {
  const SlideOutLeftExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slide-Out Left Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideOutLeftAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              onAnimationEnd: () => debugPrint('Selesai keluar ke kiri'),
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon untuk menggeser keluar ke kiri'),
          ],
        ),
      ),
    );
  }
}
