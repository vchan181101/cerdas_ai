import 'package:flutter/material.dart';
import '../../helpers/animasi/animation_helper.dart';

class AnimationGalleryScreen extends StatefulWidget {
  const AnimationGalleryScreen({super.key});

  @override
  State<AnimationGalleryScreen> createState() => _AnimationGalleryScreenState();
}

class _AnimationGalleryScreenState extends State<AnimationGalleryScreen> {
  Key _animationKey = UniqueKey();

  void _resetAllAnimations() {
    setState(() {
      _animationKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Helpers Gallery'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Putar Ulang Semua Animasi',
            onPressed: _resetAllAnimations,
          ),
        ],
      ),
      body: SingleChildScrollView(
        key: _animationKey,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ketuk pada masing-masing kartu untuk memutar ulang animasinya secara individual:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),

            _buildAnimationCard(
              title: '1. Bounce Animation',
              child: BounceAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.sports_basketball,
                  color: Colors.orange,
                  label: 'Bounce',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '2. Fade-In',
              child: FadeInAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.visibility,
                  color: Colors.blue,
                  label: 'Fade In',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '3. Fade-In Slow',
              child: FadeInSlowAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.hourglass_top,
                  color: Colors.purple,
                  label: 'Fade In Slow',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '4. Success Pop',
              child: SuccessPopAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  label: 'Success Pop',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '5. Slide-In Left',
              child: SlideInLeftAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.arrow_back,
                  color: Colors.teal,
                  label: 'Slide In Left',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '6. Slide-In Right',
              child: SlideInRightAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.arrow_forward,
                  color: Colors.indigo,
                  label: 'Slide In Right',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '7. Pulse Animation',
              child: PulseAnimationWrapper(
                child: _buildSampleBadge(
                  icon: Icons.favorite,
                  color: Colors.red,
                  label: 'Pulse',
                ),
              ),
            ),
            _buildAnimationCard(
              title: '8. Blur Reveal',
              child: const BlurRevealAnimation(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Efek Blur Reveal Premium', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _resetAllAnimations,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Reset Animasi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAnimationCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Center(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleBadge({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
