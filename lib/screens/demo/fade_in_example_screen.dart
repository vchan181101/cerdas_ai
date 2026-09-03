import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class FadeInExampleScreen extends StatelessWidget {
  const FadeInExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade-In Animation Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInAnimationWrapper(
              duration: const Duration(milliseconds: 1000),
              onTap: () {
                debugPrint('Logo diklik dan animasi fade-in diputar ulang!');
              },
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon untuk memutar ulang animasi fade-in'),
          ],
        ),
      ),
    );
  }
}
