import 'package:flutter/material.dart';
import 'package:virtusize/virtusize_sdk/virtusize_sdk.dart';

import 'animated_effects.dart';
import 'login_page.dart';

// 20.10

void main() {
  runApp(const VirtusizeDemoApp());
}

class VirtusizeDemoApp extends StatelessWidget {
  const VirtusizeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtusize SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const VirtusizeDemoScreen(),
    );
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
                  const SizedBox(height: 24),
                  AnimatedActionButton(
                    onPressed: () => _openLogin(context),
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text('Log In'),
                    colors: const [
                      Color(0xFF6366F1),
                      Color(0xFFEC4899),
                      Color(0xFFF97316),
                      Color(0xFF22D3EE),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
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
