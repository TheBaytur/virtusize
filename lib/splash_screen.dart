import 'package:flutter/material.dart';

import 'animated_effects.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      widget.onFinished();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF0B1120),
        Color(0xFF1E1B4B),
        Color(0xFF312E81),
        Color(0xFF4338CA),
      ],
      duration: const Duration(seconds: 16),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AnimatedGradientBackground(
              colors: const [
                Color(0xFF38BDF8),
                Color(0xFF6366F1),
                Color(0xFFF472B6),
                Color(0xFFF59E0B),
              ],
              borderRadius: BorderRadius.circular(40),
              padding: const EdgeInsets.all(2.4),
              duration: const Duration(seconds: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(36),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedPulse(
                      child: Icon(
                        Icons.straighten,
                        color: Colors.white,
                        size: 72,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedGradientText(
                      text: 'Welcome to Virtusize',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading your personalized size experience...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
