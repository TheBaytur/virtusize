import 'package:flutter/material.dart';

import 'package:virtusize/animated_effects.dart';
import '../recommendation.dart';
import '../recommendation_calculator.dart';
import '../size_category.dart';

// UI/UX 

class VirtusizeRecommendationView extends StatefulWidget {
  const VirtusizeRecommendationView({
    super.key,
    this.calculator = const VirtusizeCalculator(),
  });

  final VirtusizeCalculator calculator;

  @override
  State<VirtusizeRecommendationView> createState() =>
      _VirtusizeRecommendationViewState();
}

class _VirtusizeRecommendationViewState
    extends State<VirtusizeRecommendationView> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  VirtusizeRecommendation? _result;
  String? _error;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: AnimatedGradientBackground(
          colors: const [
            Color(0xFF0EA5E9),
            Color(0xFF6366F1),
            Color(0xFFEC4899),
            Color(0xFFF97316),
          ],
          borderRadius: BorderRadius.circular(28),
          duration: const Duration(seconds: 14),
          padding: const EdgeInsets.all(2),
          child: Material(
            color: Colors.transparent,
            elevation: 12,
            borderRadius: BorderRadius.circular(26),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.94),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(curved),
                        child: ScaleTransition(scale: curved, child: child),
                      ),
                    );
                  },
                  child:
                      _result == null
                          ? _buildForm(context)
                          : _buildResult(context, _result!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return KeyedSubtree(
      key: const ValueKey('form'),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Find Your Perfect Fit',
              style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Height (cm)',
              filled: true,
              fillColor: Colors.black.withOpacity(0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: _validatePositiveNumber,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              filled: true,
              fillColor: Colors.black.withOpacity(0.04),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            validator: _validatePositiveNumber,
          ),
          const SizedBox(height: 24),
          AnimatedActionButton(
            onPressed: _onSubmit,
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: const Text('Get Size Recommendation'),
            colors: const [
              Color(0xFF34D399),
              Color(0xFF60A5FA),
              Color(0xFFF97316),
              Color(0xFFEC4899),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, VirtusizeRecommendation result) {
    final size = result.size;
    return Column(
      key: const ValueKey('result'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedGradientText(
          text: 'Your Recommended Size: ${size.label}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
          colors: const [
            Color(0xFF6366F1),
            Color(0xFFF472B6),
            Color(0xFFFBBF24),
            Color(0xFF22D3EE),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'BMI: ${result.bmiLabel}',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          result.message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          size.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AnimatedPulse(
          child: OutlinedButton(
            onPressed: _reset,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a number greater than zero';
    }
    return null;
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final height = double.parse(_heightController.text);
    final weight = double.parse(_weightController.text);

    setState(() {
      try {
        _result = widget.calculator.recommend(
          heightCm: height,
          weightKg: weight,
        );
        _error = null;
      } on ArgumentError catch (err) {
        _error = err.message?.toString();
      } catch (err) {
        _error = 'Unexpected error: $err';
      }
    });
  }

  void _reset() {
    setState(() {
      _result = null;
      _error = null;
      _formKey.currentState?.reset();
      _heightController.clear();
      _weightController.clear();
    });
  }
}
