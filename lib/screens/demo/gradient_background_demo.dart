import 'package:flutter/material.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/modern_animations.dart';
import '../../core/widgets/animated_icon_button.dart';
import '../../core/theme/app_colors.dart';

/// Demo screen showcasing the GradientBackground component with modern animations
class GradientBackgroundDemo extends StatelessWidget {
  const GradientBackgroundDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Jade Sky Gradient Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with full-width gradient
            GradientBackgroundCard(
              height: 200,
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.eco_rounded,
                    size: 48,
                    color: Color(0xFF1B5E20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Jade Sky Gradient',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF0D3E14),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Animated background with smooth transitions',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1B5E20),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card variations
            Text(
              'Card Variations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),

            // Small cards grid
            Row(
              children: [
                Expanded(
                  child: StaggeredFadeIn(
                    index: 1,
                    child: GradientBackgroundCard(
                      height: 120,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, color: Color(0xFF1B5E20)),
                          SizedBox(height: 8),
                          Text('Health', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StaggeredFadeIn(
                    index: 2,
                    child: GradientBackgroundCard(
                      height: 120,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.agriculture, color: Color(0xFF1B5E20)),
                          SizedBox(height: 8),
                          Text('Farming', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StaggeredFadeIn(
                    index: 3,
                    child: GradientBackgroundCard(
                      height: 120,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, color: Color(0xFF1B5E20)),
                          SizedBox(height: 8),
                          Text('Irrigation', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StaggeredFadeIn(
                    index: 4,
                    child: GradientBackgroundCard(
                      height: 120,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud, color: Color(0xFF1B5E20)),
                          SizedBox(height: 8),
                          Text('Weather', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Interactive elements
            Text(
              'Interactive Elements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),

            // Animated buttons
            StaggeredFadeIn(
              index: 5,
              child: Row(
                children: [
                  AnimatedScaleContainer(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Button pressed!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Press Me',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedScaleContainer(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Secondary button pressed!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Secondary',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pulse animation demo
            StaggeredFadeIn(
              index: 6,
              child: Row(
                children: [
                  PulseAnimation(
                    duration: const Duration(milliseconds: 1200),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.danger.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const AnimatedIconButton(
                    icon: Icons.favorite,
                    color: AppColors.danger,
                    tooltip: 'Like',
                  ),
                  const SizedBox(width: 12),
                  const AnimatedIconButton(
                    icon: Icons.share,
                    color: AppColors.primary,
                    tooltip: 'Share',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Glassmorphism demo
            Text(
              'Glassmorphism Effect',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),

            StaggeredFadeIn(
              index: 7,
              child: GradientBackgroundCard(
                height: 150,
                borderRadius: BorderRadius.circular(20),
                child: GlassmorphismContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(16),
                  opacity: 0.4,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.ac_unit, color: Color(0xFF1B5E20)),
                      SizedBox(height: 8),
                      Text(
                        'Glass Effect',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Frosted glass overlay on gradient background',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}