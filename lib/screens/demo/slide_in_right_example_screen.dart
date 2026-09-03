import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class SlideInRightExampleScreen extends StatelessWidget {
  const SlideInRightExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slide-In Right Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideInRightAnimationWrapper(
              duration: const Duration(milliseconds: 800),
              child: const Icon(
                Icons.psychology,
                size: 140,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Elemen masuk menggeser dari kanan'),
          ],
        ),
      ),
    );
  }
}
