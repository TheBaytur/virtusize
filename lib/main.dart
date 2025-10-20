import 'package:flutter/material.dart';
import 'package:virtusize/virtusize_sdk/virtusize_sdk.dart';

import 'animated_effects.dart';
import 'login_page.dart';
import 'splash_screen.dart';

// 20.10

void main() {
  runApp(const VirtusizeDemoApp());
}

enum _AppStage { splash, login, home }

class VirtusizeDemoApp extends StatefulWidget {
  const VirtusizeDemoApp({super.key});

  @override
  State<VirtusizeDemoApp> createState() => _VirtusizeDemoAppState();
}

class _VirtusizeDemoAppState extends State<VirtusizeDemoApp> {
  _AppStage _stage = _AppStage.splash;

  void _showLogin() {
    if (!mounted) return;
    setState(() => _stage = _AppStage.login);
  }

  void _showHome() {
    if (!mounted) return;
    setState(() => _stage = _AppStage.home);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtusize SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved), child: child),
          );
        },
        child: _buildStage(),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _AppStage.splash:
        return SplashScreen(
          key: const ValueKey('splash'),
          onFinished: _showLogin,
        );
      case _AppStage.login:
        return LoginPage(
          key: const ValueKey('login'),
          onLoginSuccess: _showHome,
        );
      case _AppStage.home:
        return const VirtusizeDemoScreen(key: ValueKey('home'));
    }
  }
}

class VirtusizeDemoScreen extends StatelessWidget {
  const VirtusizeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF0F172A),
        Color(0xFF312E81),
        Color(0xFF7C3AED),
        Color(0xFF0EA5E9),
      ],
      duration: const Duration(seconds: 18),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Virtusize SDK Sample App'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 32),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: VirtusizeRecommendationView(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedGradientText(
          text: 'Virtusize Size Recommendation',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your height (cm) and weight (kg) to get a recommended clothing size based on BMI.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.85),
              ),
        ),
      ],
    );
  }
}
