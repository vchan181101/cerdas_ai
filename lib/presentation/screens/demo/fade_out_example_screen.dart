import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class FadeOutExampleScreen extends StatelessWidget {
  const FadeOutExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade-Out Animation Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeOutAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              onAnimationEnd: () {
                debugPrint('Animasi Fade-Out selesai, elemen disembunyikan.');
              },
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon di atas untuk memudar dan menghilangkannya'),
          ],
        ),
      ),
    );
  }
}
