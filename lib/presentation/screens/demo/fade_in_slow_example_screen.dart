import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class FadeInSlowExampleScreen extends StatelessWidget {
  const FadeInSlowExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade-In Slow Animation Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInSlowAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 300),
              onTap: () {
                debugPrint('Logo diklik dan animasi fade-in slow diputar ulang!');
              },
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Ketuk ikon untuk memutar ulang animasi fade-in slow'),
          ],
        ),
      ),
    );
  }
}
