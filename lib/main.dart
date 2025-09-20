import 'package:flutter/material.dart';
import 'package:virtusize/virtusize_sdk/virtusize_sdk.dart';

void main() {
  runApp(const VirtusizeDemoApp());
}

class VirtusizeDemoApp extends StatelessWidget {
  const VirtusizeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Scaffold(
      appBar: AppBar(title: const Text('Virtusize SDK Sample App')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _Header(),
            SizedBox(height: 32),
            Expanded(child: VirtusizeRecommendationView()),
          ],
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
        Text(
          'Virtusize Size Recommendation',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your height (cm) and weight (kg) to get a recommended clothing size based on BMI.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
