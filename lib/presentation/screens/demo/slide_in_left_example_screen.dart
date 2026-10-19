import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class SlideInLeftExampleScreen extends StatelessWidget {
  const SlideInLeftExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slide-In Left Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideInLeftAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Elemen masuk menggeser dari kiri'),
          ],
        ),
      ),
    );
  }
}
